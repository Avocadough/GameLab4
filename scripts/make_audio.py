"""Generate the small original audio assets used by Crystal Courier."""

from __future__ import annotations

import math
import struct
import wave
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
RATE = 22_050


def write_wav(path: Path, samples: list[float]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    peak = max(abs(sample) for sample in samples) or 1.0
    payload = b"".join(
        struct.pack("<h", int(max(-1.0, min(1.0, sample / peak * 0.72)) * 32767))
        for sample in samples
    )
    with wave.open(str(path), "wb") as output:
        output.setparams((1, 2, RATE, len(samples), "NONE", "not compressed"))
        output.writeframes(payload)
    with wave.open(str(path), "rb") as check:
        assert check.getnchannels() == 1 and check.getnframes() == len(samples)


def note(frequency: float, seconds: float, volume: float = 0.25) -> list[float]:
    count = int(RATE * seconds)
    attack = max(1, int(RATE * 0.015))
    release = max(1, int(RATE * 0.06))
    result: list[float] = []
    for index in range(count):
        envelope = min(1.0, index / attack, (count - index) / release)
        phase = 2.0 * math.pi * frequency * index / RATE
        square = 1.0 if math.sin(phase) >= 0 else -1.0
        result.append(square * volume * max(0.0, envelope))
    return result


def build_loop() -> list[float]:
    melody = [
        523.25, 659.25, 783.99, 659.25,
        587.33, 698.46, 880.00, 698.46,
        493.88, 659.25, 783.99, 987.77,
        880.00, 783.99, 659.25, 587.33,
    ]
    bass = [130.81, 146.83, 123.47, 110.00]
    beat = 0.25
    output: list[float] = []
    for index, frequency in enumerate(melody * 2):
        lead = note(frequency, beat, 0.23)
        low = note(bass[(index // 4) % len(bass)], beat, 0.12)
        output.extend(a + b for a, b in zip(lead, low))
    return output


def build_respawn() -> list[float]:
    output: list[float] = []
    for frequency in (392.00, 523.25, 659.25, 783.99):
        output.extend(note(frequency, 0.09, 0.32))
    return output


if __name__ == "__main__":
    write_wav(ROOT / "Assets/Sound/crystal_route.wav", build_loop())
    write_wav(ROOT / "Assets/Sound/FX/respawn.wav", build_respawn())
    print("Generated crystal_route.wav and respawn.wav")
