const localtunnel = require('localtunnel');
const fs = require('fs');

(async () => {
  const opts = { port: 3000, subdomain: 'wma-testgen-demo' };
  let tunnel;
  async function connect() {
    try {
      tunnel = await localtunnel(opts);
      const url = tunnel.url;
      console.log('TUNNEL_URL=' + url);
      fs.writeFileSync('tunnel.url', url);
      tunnel.on('close', () => { setTimeout(connect, 2000); }); // auto-reconnect
      tunnel.on('error', () => { setTimeout(connect, 2000); });
    } catch {
      // subdomain taken — fall back to random
      const t = await localtunnel({ port: 3000 });
      const url = t.url;
      console.log('TUNNEL_URL=' + url);
      fs.writeFileSync('tunnel.url', url);
      t.on('close', () => { setTimeout(connect, 2000); });
    }
  }
  await connect();
  process.stdin.resume();
})();
