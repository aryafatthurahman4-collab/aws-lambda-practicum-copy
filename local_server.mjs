import http from 'node:http';
import { handler } from './index.mjs';

const PORT = 9000;
let functionUrlActive = process.env.FUNCTION_URL_DELETED !== '1';

// Simulasi event Lambda Function URL
const createLambdaEvent = (req) => {
  return {
    requestContext: {
      http: {
        method: req.method,
        path: req.url,
      },
    },
    rawPath: req.url,
    path: req.url,
    headers: req.headers,
    httpMethod: req.method,
  };
};

const server = http.createServer(async (req, res) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);

  // Endpoint khusus untuk simulasi delete Function URL
  if (req.url === '/delete-function-url' && req.method === 'POST') {
    functionUrlActive = false;
    res.statusCode = 200;
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify({ status: 'deleted', message: 'Function URL has been deleted' }));
    console.log(`[${new Date().toISOString()}] Function URL deleted via API`);
    return;
  }

  // Endpoint untuk mengaktifkan kembali
  if (req.url === '/activate-function-url' && req.method === 'POST') {
    functionUrlActive = true;
    res.statusCode = 200;
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify({ status: 'active', message: 'Function URL has been activated' }));
    console.log(`[${new Date().toISOString()}] Function URL activated via API`);
    return;
  }

  try {
    // Jika Function URL sudah dihapus (di-delete), kembalikan {"Message":null}
    if (!functionUrlActive) {
      res.statusCode = 404;
      res.setHeader('Content-Type', 'application/json');
      res.end(JSON.stringify({ Message: null }));
      console.log(`[${new Date().toISOString()}] Function URL deleted - returning {Message:null}`);
      return;
    }

    // Buat event object yang mensimulasikan Lambda Function URL
    const event = createLambdaEvent(req);

    // Panggil handler Lambda
    const response = await handler(event);

    // Set headers dari response Lambda
    if (response.headers) {
      Object.entries(response.headers).forEach(([key, value]) => {
        res.setHeader(key, value);
      });
    }

    // Set status code dan body
    res.statusCode = response.statusCode || 200;
    res.end(response.body);

    console.log(`[${new Date().toISOString()}] Response: ${response.statusCode}`);
  } catch (error) {
    console.error('Error:', error);
    res.statusCode = 500;
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify({ error: error.message }));
  }
});

server.listen(PORT, () => {
  console.log('='.repeat(60));
  console.log('AWS Lambda Local Simulator (Function URL)');
  console.log('='.repeat(60));
  console.log(`Server berjalan di: http://localhost:${PORT}`);
  console.log(`Akses dari browser: http://localhost:${PORT}`);
  console.log(`Akses dari WSL 2: curl http://localhost:${PORT}`);
  console.log('='.repeat(60));
  console.log('Status Function URL: ACTIVE');
  console.log('Ketik "confirm" di terminal ini untuk simulasi delete Function URL');
  console.log('Tekan Ctrl+C untuk menghentikan server');
  console.log('='.repeat(60));
});

// Setup stdin untuk simulasi "confirm" command
process.stdin.setEncoding('utf8');
process.stdin.on('data', (data) => {
  const input = data.trim().toLowerCase();

  if (input === 'confirm') {
    functionUrlActive = false;
    console.log('='.repeat(60));
    console.log('FUNCTION URL TELAH DIHAPUS (Simulasi)');
    console.log('='.repeat(60));
    console.log('Refresh browser untuk melihat: {"Message":null}');
    console.log('Restart server untuk mengaktifkan kembali');
    console.log('='.repeat(60));
  } else if (input === 'exit' || input === 'quit') {
    console.log('Menghentikan server...');
    server.close();
    process.exit(0);
  }
});

console.log('Prompt command aktif. Ketik "confirm" untuk delete Function URL');
