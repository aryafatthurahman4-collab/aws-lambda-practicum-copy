import { readFileSync } from 'node:fs';

const htmlTemplate = readFileSync(new URL('./index.html', import.meta.url), 'utf8');

const escapeHtml = (value) =>
  String(value).replace(/[&<>"']/g, (character) => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
  })[character]);

export const handler = async (event = {}) => {
  const method = event?.requestContext?.http?.method || event?.httpMethod || 'GET';
  const path = event?.rawPath || event?.path || '/';
  const userAgent = event?.headers?.['user-agent'] || event?.headers?.['User-Agent'] || 'unknown';
  const timestamp = new Date().toISOString();

  const values = {
    METHOD: method,
    PATH: path,
    USER_AGENT: userAgent,
    TIMESTAMP: timestamp,
  };
  const body = htmlTemplate.replace(
    /\{\{(METHOD|PATH|USER_AGENT|TIMESTAMP)\}\}/g,
    (_placeholder, key) => escapeHtml(values[key]),
  );

  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html; charset=utf-8',
    },
    body,
  };
};
