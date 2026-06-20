#!/usr/bin/env python3
"""
Generate SFX WAV assets by replicating the procedural synthesis formulas from the
original Kotlin SoundManager.kt (sweep click, bell-wave chimes, etc.).

Run once: python3 tool/generate_sfx.py
Outputs mono 16-bit PCM WAV files into assets/audio/.
"""
import math
import os
import struct
import wave

SAMPLE_RATE = 22050
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "audio")


def sine(freq, t):
    return math.sin(2.0 * math.pi * freq * t)


def bell_wave(freq, t):
    # fundamental sine + 2nd harmonic (octave) + 3rd harmonic for brightness,
    # with a very brief attack to avoid clicks (mirrors SoundManager.bellWave)
    attack = (t / 0.02) if t < 0.02 else 1.0
    return attack * (0.65 * sine(freq, t) + 0.25 * sine(freq * 2.0, t) + 0.10 * sine(freq * 3.0, t))


def write_wav(name, samples):
    path = os.path.join(OUT_DIR, name)
    # clamp to int16
    frames = bytearray()
    for s in samples:
        v = int(max(-32768, min(32767, s)))
        frames += struct.pack("<h", v)
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SAMPLE_RATE)
        w.writeframes(bytes(frames))
    print(f"wrote {name} ({len(samples)} samples)")


def gen_click():
    duration = 0.06
    n = int(SAMPLE_RATE * duration)
    out = []
    for i in range(n):
        t = i / SAMPLE_RATE
        freq = 1200.0 - (t / duration) * 600.0
        vol = (1.0 - (i / n)) * 8000.0
        out.append(sine(freq, t) * vol)
    return out


def gen_tick():
    duration = 0.02
    n = int(SAMPLE_RATE * duration)
    out = []
    for i in range(n):
        t = i / SAMPLE_RATE
        vol = (1.0 - (i / n)) * 8000.0
        out.append(sine(1200.0, t) * vol)
    return out


def gen_chime(notes, dur, vol_peak, last_sustain=False):
    note_len = int(SAMPLE_RATE * dur)
    out = []
    for ni, freq in enumerate(notes):
        for i in range(note_len):
            t = i / SAMPLE_RATE
            decay = i / note_len
            if last_sustain and ni == len(notes) - 1:
                vol = (1.0 - decay * 0.3) * vol_peak
            else:
                vol = (1.0 - decay) * vol_peak
            out.append(bell_wave(freq, t) * vol)
    return out


def gen_correct():
    return gen_chime([523.25, 659.25, 783.99, 1046.50], 0.08, 11000.0)


def gen_incorrect():
    return gen_chime([466.16, 349.23], 0.18, 8000.0)


def gen_victory():
    return gen_chime([523.25, 659.25, 783.99, 1046.50, 1318.51, 1567.98], 0.10, 11000.0, last_sustain=True)


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    write_wav("click.wav", gen_click())
    write_wav("tick.wav", gen_tick())
    write_wav("correct.wav", gen_correct())
    write_wav("incorrect.wav", gen_incorrect())
    write_wav("victory.wav", gen_victory())


if __name__ == "__main__":
    main()
