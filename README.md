# 🎬 Kina Studyjne w Polsce

Mapa + lista kin studyjnych (Sieć Kin Studyjnych) z cenami biletów i orientacyjną liczbą seansów.

**Live:** https://sajgonara.github.io/kina-studyjne/

## Funkcje
- Interaktywna mapa (Leaflet + CARTO dark)
- Sortowanie: najtańszy bilet, bilet normalny, liczba seansów/dzień, miasto, nazwa
- Filtr po mieście + wyszukiwarka
- Linki do stron i repertuarów kin

## Dane
Brak publicznego API dla kin studyjnych (repertuary rozproszone po systemach bilety24/OKI/własnych) —
dane zebrane ręcznie ze stron kin (lipiec 2026) i zapisane w `data.js`. Ceny mogą się zmieniać;
pozycje oznaczone `verified: false` to szacunki. PR-y z poprawkami mile widziane.

Źródło listy kin: [Sieć Kin Studyjnych](https://stowarzyszeniekinstudyjnych.pl/) (247 kin; tu podzbiór z Wikipedii + research).
