const puppeteer = require('puppeteer-core');
const path = require('path');
const fs = require('fs');

const EDGE_PATHS = [
  'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe',
  'C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe',
];

async function findEdge() {
  for (const p of EDGE_PATHS) {
    if (fs.existsSync(p)) return p;
  }
  throw new Error('Microsoft Edge not found. Install Edge or set EDGE_PATH env var.');
}

async function run() {
  const edgePath = process.env.EDGE_PATH || await findEdge();
  console.log(`Using browser: ${edgePath}`);

  const browser = await puppeteer.launch({
    executablePath: edgePath,
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--window-size=1400,900'],
  });

  const page = await browser.newPage();
  await page.setViewport({ width: 1400, height: 900 });

  const url = 'http://localhost:3000';
  console.log(`Navigating to ${url} …`);
  await page.goto(url, { waitUntil: 'networkidle0', timeout: 30000 });

  // Wait for fonts and animations
  await new Promise(r => setTimeout(r, 2000));

  const screenshotsDir = path.join(__dirname, 'screenshots');
  if (!fs.existsSync(screenshotsDir)) fs.mkdirSync(screenshotsDir);

  // ── Screenshot 1: Hero section ──
  await page.evaluate(() => window.scrollTo(0, 0));
  await new Promise(r => setTimeout(r, 500));
  await page.screenshot({ path: path.join(screenshotsDir, '01-hero.png'), fullPage: false });
  console.log('Screenshot: 01-hero.png');

  // ── Screenshot 2: Stats bar ──
  const statsEl = await page.$('#stats');
  if (statsEl) {
    await statsEl.screenshot({ path: path.join(screenshotsDir, '02-stats.png') });
    console.log('Screenshot: 02-stats.png');
  }

  // ── Screenshot 3: How It Works ──
  await page.evaluate(() => document.getElementById('how').scrollIntoView());
  await new Promise(r => setTimeout(r, 800));
  await page.screenshot({ path: path.join(screenshotsDir, '03-how-it-works.png'), fullPage: false });
  console.log('Screenshot: 03-how-it-works.png');

  // ── Screenshot 4: Demo section (before generate) ──
  await page.evaluate(() => document.getElementById('demo').scrollIntoView());
  await new Promise(r => setTimeout(r, 800));
  await page.screenshot({ path: path.join(screenshotsDir, '04-demo-before.png'), fullPage: false });
  console.log('Screenshot: 04-demo-before.png');

  // ── Screenshot 5: Demo after generate ──
  await page.click('#generate-btn');
  await new Promise(r => setTimeout(r, 5000)); // wait for all cards to appear
  await page.screenshot({ path: path.join(screenshotsDir, '05-demo-after.png'), fullPage: false });
  console.log('Screenshot: 05-demo-after.png');

  // ── Screenshot 6: Results section ──
  await page.evaluate(() => document.getElementById('results').scrollIntoView());
  await new Promise(r => setTimeout(r, 1200));
  await page.screenshot({ path: path.join(screenshotsDir, '06-results.png'), fullPage: false });
  console.log('Screenshot: 06-results.png');

  // ── Screenshot 7: ROI section ──
  await page.evaluate(() => document.getElementById('roi').scrollIntoView());
  await new Promise(r => setTimeout(r, 800));
  await page.screenshot({ path: path.join(screenshotsDir, '07-roi.png'), fullPage: false });
  console.log('Screenshot: 07-roi.png');

  // ── Screenshot 8: Timeline / CTA ──
  await page.evaluate(() => document.getElementById('cta').scrollIntoView());
  await new Promise(r => setTimeout(r, 800));
  await page.screenshot({ path: path.join(screenshotsDir, '08-cta.png'), fullPage: false });
  console.log('Screenshot: 08-cta.png');

  // ── Generate full-page PDF ──
  // Reset scroll before PDF
  await page.evaluate(() => window.scrollTo(0, 0));
  await new Promise(r => setTimeout(r, 500));

  const pdfPath = path.join(__dirname, 'WMA-TestGen-Client-Pitch.pdf');
  await page.pdf({
    path: pdfPath,
    format: 'A4',
    printBackground: true,
    margin: { top: '10mm', bottom: '10mm', left: '0mm', right: '0mm' },
    displayHeaderFooter: false,
  });
  console.log(`\nPDF saved: ${pdfPath}`);
  console.log(`Screenshots saved in: ${screenshotsDir}`);

  await browser.close();
  console.log('\nDone.');
}

run().catch(err => { console.error(err); process.exit(1); });
