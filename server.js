require('dotenv').config();
const express = require('express');
const Anthropic = require('@anthropic-ai/sdk');
const path = require('path');
const SYSTEM_PROMPT = require('./prompts/system');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json({ limit: '50kb' }));

// ── Health check ──────────────────────────────────────────────
app.get('/api/health', (req, res) => {
  const hasKey = !!process.env.ANTHROPIC_API_KEY;
  res.json({ status: 'ok', model: 'claude-sonnet-4-6', apiKey: hasKey });
});

// ── Generate test suite — Server-Sent Events stream ──────────
app.post('/api/generate', async (req, res) => {
  const { bsd } = req.body || {};

  if (!process.env.ANTHROPIC_API_KEY) {
    return res.status(500).json({
      error: 'ANTHROPIC_API_KEY is not set. Add it to a .env file and restart the server.'
    });
  }
  if (!bsd || bsd.trim().length < 20) {
    return res.status(400).json({ error: 'BSD text is too short or missing.' });
  }

  // SSE headers
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.flushHeaders();

  const send = (data) => res.write(`data: ${JSON.stringify(data)}\n\n`);

  try {
    const client = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

    const userMessage = `=== BSD ===\n${bsd.trim()}\n\n=== INSTRUCTION ===\nGenerate the full test-case suite and documentation for the target module named in the BSD, following your operating procedure. Use markdown formatting with clear headings for each artifact and phase.`;

    const stream = client.messages.stream({
      model: 'claude-sonnet-4-6',
      max_tokens: 8000,
      system: SYSTEM_PROMPT,
      messages: [{ role: 'user', content: userMessage }],
    });

    for await (const event of stream) {
      if (
        event.type === 'content_block_delta' &&
        event.delta?.type === 'text_delta'
      ) {
        send({ type: 'text', text: event.delta.text });
      }
    }

    const finalMsg = await stream.finalMessage();
    send({
      type: 'done',
      inputTokens: finalMsg.usage?.input_tokens,
      outputTokens: finalMsg.usage?.output_tokens,
    });
  } catch (err) {
    console.error('Claude API error:', err.message);
    send({ type: 'error', message: err.message });
  } finally {
    res.end();
  }
});

app.get('/', (req, res) =>
  res.sendFile(path.join(__dirname, 'public', 'index.html'))
);

app.listen(PORT, () => {
  const hasKey = !!process.env.ANTHROPIC_API_KEY;
  console.log(`\n  ╔══════════════════════════════════════════════╗`);
  console.log(`  ║   TestGen AI                                 ║`);
  console.log(`  ║   http://localhost:${PORT}                    ║`);
  console.log(`  ║   Model : claude-sonnet-4-6                  ║`);
  console.log(`  ║   API key: ${hasKey ? '✓ loaded' : '✗ MISSING — add to .env'}            ║`);
  console.log(`  ╚══════════════════════════════════════════════╝\n`);
});
