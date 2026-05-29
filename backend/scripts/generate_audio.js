// Generate placeholder audio files (WAV format, 16-bit PCM)
// Usage: node scripts/generate_audio.js

const { writeFileSync, mkdirSync, existsSync } = require('fs');
const { join } = require('path');

const SAMPLE_RATE = 22050;
const DURATION = 0.5; // seconds
const BITS = 16;

function createWav(samples) {
  const dataSize = samples.length * (BITS / 8);
  const headerSize = 44;
  const fileSize = headerSize + dataSize;

  const buf = Buffer.alloc(fileSize);

  // RIFF header
  buf.write('RIFF', 0);
  buf.writeUInt32LE(fileSize - 8, 4);
  buf.write('WAVE', 8);

  // fmt chunk
  buf.write('fmt ', 12);
  buf.writeUInt32LE(16, 16); // chunk size
  buf.writeUInt16LE(1, 20);  // PCM
  buf.writeUInt16LE(1, 22);  // mono
  buf.writeUInt32LE(SAMPLE_RATE, 24);
  buf.writeUInt32LE(SAMPLE_RATE * (BITS / 8), 28); // byte rate
  buf.writeUInt16LE(BITS / 8, 32); // block align
  buf.writeUInt16LE(BITS, 34);

  // data chunk
  buf.write('data', 36);
  buf.writeUInt32LE(dataSize, 40);

  for (let i = 0; i < samples.length; i++) {
    const v = Math.max(-32768, Math.min(32767, Math.round(samples[i])));
    buf.writeInt16LE(v, headerSize + i * 2);
  }

  return buf;
}

function generateTone(freqs, durations) {
  const totalSamples = Math.floor(SAMPLE_RATE * durations.reduce((a, b) => a + b, 0));
  const samples = new Float64Array(totalSamples);

  let offset = 0;
  for (let i = 0; i < freqs.length; i++) {
    const n = Math.floor(SAMPLE_RATE * durations[i]);
    for (let j = 0; j < n; j++) {
      const t = j / SAMPLE_RATE;
      const envelope = 1 - (j / n); // fade out
      samples[offset + j] = Math.sin(2 * Math.PI * freqs[i] * t) * 16000 * envelope;
    }
    offset += n;
  }

  return samples;
}

const outputDir = join(__dirname, '..', '..', 'assets', 'audio');
if (!existsSync(outputDir)) mkdirSync(outputDir, { recursive: true });

// Correct: happy ascending tone (C5 -> E5)
writeFileSync(
  join(outputDir, 'correct.wav'),
  createWav(generateTone([523, 659], [DURATION / 2, DURATION / 2]))
);

// Wrong: soft low tone
writeFileSync(
  join(outputDir, 'wrong.wav'),
  createWav(generateTone([220], [DURATION]))
);

// Celebration: cheerful melody
writeFileSync(
  join(outputDir, 'celebration.wav'),
  createWav(generateTone([523, 659, 784, 1047], [0.15, 0.15, 0.15, 0.5]))
);

console.log('Audio files generated in', outputDir);
