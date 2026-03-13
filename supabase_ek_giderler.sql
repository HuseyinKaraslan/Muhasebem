-- Ek giderler sekmesi için tablo.
-- Supabase SQL Editor'da çalıştırın.

CREATE TABLE IF NOT EXISTS ek_giderler (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  aciklama text NOT NULL,
  tutar numeric NOT NULL,
  tarih timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ek_giderler_tarih_idx ON ek_giderler (tarih DESC);

