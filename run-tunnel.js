const lt = require('localtunnel');
const fs = require('fs');
const path = require('path');

async function go() {
  let t;
  try { t = await lt({port:3000, subdomain:'testgen-ai-demo'}); }
  catch { t = await lt({port:3000}); }
  fs.writeFileSync(path.join('C:\\Users\\anura\\OneDrive\\Desktop\\aiTesting\\wma-testgen', 'tunnel.url'), t.url);
  process.stdout.write('TUNNEL=' + t.url + '\n');
  t.on('close', ()=>{ go(); });
  process.stdin.resume();
}
go();
