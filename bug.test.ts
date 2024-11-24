import { afterEach, beforeEach, describe, expect, test } from 'vitest';
import { startUnleash, destroy, type Context, isEnabled } from 'unleash-client';

describe.each([
  [
    'Using Direct Unleash Server API',
    'http://localhost:4242/api',
    'default:development.unleash-insecure-api-token',
  ],
  [
    'Using Proxy Server Side Config Token',
    'http://localhost:3000/proxy',
    'server-side-sdk-token',
  ],
])('%s', async (_, url, token) => {
  beforeEach(async () => {
    await startUnleash({
      url,
      appName: 'test',
      customHeaders: { Authorization: token },
    });
  });

  afterEach(async () => {
    destroy();
    // Unleash doesn't like rapid fire querying, let's space it out
    await new Promise((r) => setTimeout(r, 500));
  });

  test('Should be disabled for user not in segment', () => {
    expect(
      isEnabled('TestFeature', {
        userId: 'randomuser',
      })
    ).toBe(false);
  });

  test('Should be enabled for user in segment', () => {
    expect(
      isEnabled('TestFeature', {
        userId: 'someuser',
      })
    ).toBe(true);
  });
});
