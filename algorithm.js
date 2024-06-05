let tk = new Date("2024,4,15"); //tanggal kembali
let tp = new Date("2024,4,1"); //tanggal pinjam
let bmp = 14; //batas maximum pinjaman
let dh = 1000; //denda harian
let dm = 30000; //denda maximum
let books = [
  //daftar buku
  {
    id: "BOOK001",
    title: "Buku 1",
  },
  {
    id: "BOOK002",
    title: "Buku 2",
  },
  {
    id: "BOOK003",
    title: "Buku 3",
  },
];

//HITUNG PENALTI
const calculatePenalty = (
  tanggalKembali,
  tanggalPinjam,
  batasMaxPinjaman,
  dendaHarian,
  dendaMaximum,
  daftarBuku
) => {
  let totalDenda = 0;
  let dendaPerBuku = [];
  let oneDayInMillisecond = 1000 * 3600 * 24;
  let durasiPinjam =
    (tanggalKembali.getTime() - tanggalPinjam.getTime()) / oneDayInMillisecond +
    1;

  for (let i = 0; i < daftarBuku.length; i++) {
    if (durasiPinjam > batasMaxPinjaman) {
      let selisih = durasiPinjam - batasMaxPinjaman;
      if (selisih * dendaHarian > dendaMaximum) {
        denda = dendaMaximum;
      } else {
        denda = selisih * dendaHarian;
      }
      dendaPerBuku.push(denda);
      totalDenda += denda;
    }
  }

  let data = { totalDenda, dendaPerBuku };
  console.log(data);
  return data;
};

//TEST FUNGSI
calculatePenalty(tk, tp, bmp, dh, dm, books);
