package com.example

data class Question(
    val id: String,
    val levelId: Int,
    val stageId: Int,
    val text: String,
    val options: List<String>,
    val correctAnswerIndex: Int,
    val observationTimeSecs: Int, // 0 if no observation phase needed
    val explanation: String,
    val graphicType: GraphicType,
    val graphicData: List<String> = emptyList() // Custom string list to tell the renderer what to draw
)

enum class GraphicType {
    EMOJI_ROW,             // Renders emoji row (Level 1 Q1, Q3, Q4, Q7, Q8, Q10)
    GEOMETRIC_NUMBERS,     // Geometric numbers cards (Level 1 Q2)
    PLAYLIST_CARDS,        // Simulated playlist album arts (Level 1 Q5)
    SOCIAL_ICONS,          // Social medial brand icons (Level 1 Q6)
    TRAFFIC_LIGHTS,        // Natively drawn traffic light structures (Level 1 Q9)
    WHITEBOARD_LETTERS,    // Red letter chalkboard memory (Level 2 Q1)
    WOOD_ROOM,             // Classroom wooden elements (Level 2 Q2)
    POST_IT_NOTES,         // Even numbers paper squares (Level 2 Q3)
    LETTER_BUBBLES,        // Rounded text bubble rows (Level 2 Q4, Q5, Q6, Q7, Q8, Q9, Q10)
    SPATIAL_CAMPUS,        // Simulated spatial drawing of campus layout (Level 3 Q1)
    SPATIAL_OFFICE,        // Simulated spatial drawing of laptop office workspace (Level 3 Q2, Q3, Q8)
    SPATIAL_PARK,          // Landscape park garden with elements (Level 3 Q4)
    SPATIAL_PARKING,       // Parking spots with vehicle spatial positions (Level 3 Q5, Q10)
    SPATIAL_CLASSROOM,     // Classroom whiteboard/door spatial drawing (Level 3 Q6)
    SPATIAL_LIBRARY,       // Library bookshelves and lamps (Level 3 Q7)
    SPATIAL_DINER          // Cafe/diner kitchen cashier placement (Level 3 Q9)
}

object QuizQuestions {
    val levelNames = mapOf(
        1 to "Memory & Sequence",
        2 to "Focus & Filter",
        3 to "Spatial Observation"
    )

    val levelDescriptions = mapOf(
        1 to "Ingat dan urutkan urutan simbol, angka, gambar gajah, aktivitas pagi, hingga rambu lalu lintas yang telah dilihat.",
        2 to "Perhatikan detail kecil, saring distraksi, dan cari pola angka atau huruf tertentu yang diinginkan.",
        3 to "Amatilah letak posisi benda di ruangan, taman, jalanan, atau kantor Anda selama beberapa detik sebelum menjawab."
    )

    fun getQuestions(): List<Question> {
        return listOf(
            // ==================== LEVEL 1 (Memory & Sequence, Observation: 15s) ====================
            Question(
                id = "l1q1",
                levelId = 1,
                stageId = 1,
                text = "Perhatikan simbol-simbol berikut lalu susun kembali urutan yang benar!",
                options = listOf(
                    "Petir, musik, Hati, stik",
                    "Stik, musik, Hati, petir",
                    "Hati, stik, petir, musik",
                    "Hati, petir, stik, musik"
                ),
                correctAnswerIndex = 2,
                observationTimeSecs = 15,
                explanation = "Urutan awal simbol di atas adalah Hati (❤️), Stik/Gamepad (🎮), Petir (⚡), Musik (🎵). Jawaban: Hati, stik, petir, musik.",
                graphicType = GraphicType.EMOJI_ROW,
                graphicData = listOf("❤️", "🎮", "⚡", "🎵")
            ),
            Question(
                id = "l1q2",
                levelId = 1,
                stageId = 2,
                text = "Ingat urutan angka pada simbol berikut. Pilihlah urutan angka pada simbol yang sesuai!",
                options = listOf("4, 2, 3, 1", "1, 2, 3, 4", "2, 1, 3, 4", "1, 3, 4, 2"),
                correctAnswerIndex = 1,
                observationTimeSecs = 15,
                explanation = "Simbol-simbol tersebut diurutkan secara logis dari angka 1, 2, 3, hingga 4. Jawaban: 1, 2, 3, 4.",
                graphicType = GraphicType.GEOMETRIC_NUMBERS,
                graphicData = listOf("1", "2", "3", "4")
            ),
            Question(
                id = "l1q3",
                levelId = 1,
                stageId = 3,
                text = "Perhatikan gambar dibawah ini dan ingatlah urutan gambar tersebut! Pilih urutan yang sesuai.",
                options = listOf(
                    "Piala, kaca pembesar, bantal, kupu-kupu",
                    "Bantal, piala, kupu-kupu, kaca pembesar",
                    "Bantal, piala, kaca pembesar, kupu-kupu",
                    "Kaca pembesar, piala, bantal, kupu-kupu"
                ),
                correctAnswerIndex = 2,
                observationTimeSecs = 15,
                explanation = "Urutan gambar yang diperlihatkan adalah bantal (🛏️), piala (🏆), kaca pembesar (🔍), dan kupu-kupu (🦋).",
                graphicType = GraphicType.EMOJI_ROW,
                graphicData = listOf("🛏️", "🏆", "🔍", "🦋")
            ),
            Question(
                id = "l1q4",
                levelId = 1,
                stageId = 4,
                text = "Perhatikan urutan ikon di bawah ini! Masukkan kembali urutan hewan yang benar!",
                options = listOf(
                    "Singa, angsa, tikus, gajah",
                    "Angsa, singa, tikus, gajah",
                    "Gajah, angsa, singa, tikus",
                    "Gajah, singa, tikus, angsa"
                ),
                correctAnswerIndex = 3,
                observationTimeSecs = 15,
                explanation = "Hewan diurutkan dari Gajah (🐘), Singa (🦁), Tikus (🐭), dan Angsa (🦢). Jawaban: Gajah, singa, tikus, angsa.",
                graphicType = GraphicType.EMOJI_ROW,
                graphicData = listOf("🐘", "🦁", "🐭", "🦢")
            ),
            Question(
                id = "l1q5",
                levelId = 1,
                stageId = 5,
                text = "Ingatlah urutan playlist lagu berikut! Urutkan playlist tersebut berdasarkan nama penyanyinya!",
                options = listOf(
                    "Tulus, Maliq, Rizky Febian, Payung Teduh",
                    "Payung Teduh, Tulus, Maliq, Rizky Febian",
                    "Payung Teduh, Tulus, Rizky Febian, Maliq",
                    "Maliq, Tulus, Payung Teduh, Rizky Febian"
                ),
                correctAnswerIndex = 1,
                observationTimeSecs = 15,
                explanation = "Penyanyi playlist berurut dari Payung Teduh (Akad), Tulus (Teman Hidup), Maliq (Kita Bikin Romantis), lalu Rizky Febian (Bermuara).",
                graphicType = GraphicType.PLAYLIST_CARDS,
                graphicData = listOf("Akad", "Teman Hidup", "Kita Bikin Romantis", "Bermuara")
            ),
            Question(
                id = "l1q6",
                levelId = 1,
                stageId = 6,
                text = "Perhatikan urutan media sosial dibawah ini! Ketik ulang urutan yang benar dari kiri ke kanan!",
                options = listOf(
                    "Instagram, Tiktok, Whatsapp, Facebook",
                    "Instagram, Tiktok, Facebook, Whatsapp",
                    "Tiktok, Instagram, Whatsapp, Facebook",
                    "Whatsapp, Tiktok, Facebook, Instagram"
                ),
                correctAnswerIndex = 0,
                observationTimeSecs = 15,
                explanation = "Urutan media sosial dari kiri ke kanan adalah Instagram, Tiktok, Whatsapp, dan Facebook.",
                graphicType = GraphicType.SOCIAL_ICONS,
                graphicData = listOf("Instagram", "Tiktok", "Whatsapp", "Facebook")
            ),
            Question(
                id = "l1q7",
                levelId = 1,
                stageId = 7,
                text = "Tuliskan kembali urutan aktivitas Anda untuk memulai aktivitas di pagi hari!",
                options = listOf(
                    "tidur - bangun tidur - mandi - memasak",
                    "Mandi - memasak - tidur - bangun tidur",
                    "Tidur - bangun tidur - memasak - mandi",
                    "Bangun tidur - tidur - mandi - memasak"
                ),
                correctAnswerIndex = 0,
                observationTimeSecs = 15,
                explanation = "Logika urutan aktivitas: Tidur (😴) -> Bangun (🛌) -> Mandi (🚿) -> Memasak (🍳). Jawaban: tidur - bangun tidur - mandi - memasak.",
                graphicType = GraphicType.EMOJI_ROW,
                graphicData = listOf("😴", "🛌", "🚿", "🍳")
            ),
            Question(
                id = "l1q8",
                levelId = 1,
                stageId = 8,
                text = "Perhatikan dan ingatlah urutan moda transportasi berkode darat, udara, dan air berikut!",
                options = listOf(
                    "Kapal, bus, pesawat",
                    "Bus, pesawat, kapal",
                    "Kapal, pesawat, bus",
                    "Pesawat, bus, kapal"
                ),
                correctAnswerIndex = 1,
                observationTimeSecs = 15,
                explanation = "Kombinasi darat (Bus), udara (Pesawat), dan air (Kapal). Urutannya: Bus, pesawat, kapal.",
                graphicType = GraphicType.EMOJI_ROW,
                graphicData = listOf("🚌", "✈️", "🚢")
            ),
            Question(
                id = "l1q9",
                levelId = 1,
                stageId = 9,
                text = "Ingatlah urutan lampu rambu lalu lintas yang menyala berikut! Pilih urutan warna lampu yang sesuai!",
                options = listOf(
                    "Kuning, Hijau, Merah",
                    "Hijau, Kuning, Merah",
                    "Merah, Kuning, Hijau",
                    "Merah, Hijau, Kuning"
                ),
                correctAnswerIndex = 2,
                observationTimeSecs = 15,
                explanation = "Rambu ke-1 menyala Merah (Atas), ke-2 menyala Kuning (Tengah), ke-3 menyala Hijau (Bawah). Urutannya: Merah, Kuning, Hijau.",
                graphicType = GraphicType.TRAFFIC_LIGHTS,
                graphicData = listOf("Red", "Yellow", "Green")
            ),
            Question(
                id = "l1q10",
                levelId = 1,
                stageId = 10,
                text = "Perhatikan beberapa kondisi cuaca berikut! Pilih urutan kondisi cuaca yang benar dari gambar tersebut!",
                options = listOf(
                    "Badai, bersalju, cerah",
                    "Cerah, badai, bersalju",
                    "Bersalju, cerah, badai",
                    "Cerah, bersalju, badai"
                ),
                correctAnswerIndex = 0,
                observationTimeSecs = 15,
                explanation = "Gambar 1 adalah badai petir (⛈️), Gambar 2 adalah salju pegunungan (❄️), Gambar 3 adalah hari yang cerah (☀️). Urutannya: Badai, bersalju, cerah.",
                graphicType = GraphicType.EMOJI_ROW,
                graphicData = listOf("⛈️", "❄️", "☀️")
            ),

            // ==================== LEVEL 2 (Focus & Filter, Observation: 0s / Immediately) ====================
            Question(
                id = "l2q1",
                levelId = 2,
                stageId = 1,
                text = "Perhatikan dan amatilah hanya huruf yang berwarna merah. Sebutkan kembali huruf-huruf merah tersebut!",
                options = listOf("K, P, M", "M, P, K", "M, K, P", "K, M, P"),
                correctAnswerIndex = 2,
                observationTimeSecs = 5,
                explanation = "Huruf yang dicat dengan warna merah di papan tulis adalah M (atas), K (kiri), dan P (kanan). Jawaban: M, K, P.",
                graphicType = GraphicType.WHITEBOARD_LETTERS,
                graphicData = listOf("M", "K", "P")
            ),
            Question(
                id = "l2q2",
                levelId = 2,
                stageId = 2,
                text = "Perhatikan dan saring objeknya! Cari dan pilih benda-benda yang hanya terbuat dari bahan kayu!",
                options = listOf("Buku, Pensil", "Pensil, Penggaris", "Meja, Kursi", "Pensil, Kayu"),
                correctAnswerIndex = 2,
                observationTimeSecs = 5,
                explanation = "Benda kayu utama di dalam ruang kelas pada gambar adalah Meja dan Kursi siswa. Jawaban: Meja, Kursi.",
                graphicType = GraphicType.WOOD_ROOM,
                graphicData = listOf("Meja", "Kursi")
            ),
            Question(
                id = "l2q3",
                levelId = 2,
                stageId = 3,
                text = "Pertajam fokusmu dan amati hanya angka-angka genap! Susun kembali urutan angka genap tersebut!",
                options = listOf("8, 4, 3", "9, 8, 3", "8, 4, 2", "8, 2, 6"),
                correctAnswerIndex = 2,
                observationTimeSecs = 5,
                explanation = "Angka genap pada kertas memo tempel adalah 8, 4, dan 2. Jawaban: 8, 4, 2.",
                graphicType = GraphicType.POST_IT_NOTES,
                graphicData = listOf("3", "8", "5", "4", "9", "2") // 8, 4, 2 are evens
            ),
            Question(
                id = "l2q4",
                levelId = 2,
                stageId = 4,
                text = "Fokus pada huruf di posisi ganjil (posisi ke-1, ke-3, ke-5) dari kiri ke kanan pada deretan berikut!",
                options = listOf("M, K, P", "K, P, M", "M, P, K", "P, M, K"),
                correctAnswerIndex = 2,
                observationTimeSecs = 5,
                explanation = "Deretan: M(1), K(2), P(3), M(4), K(5), P(6). Posisi ganjil adalah ke-1 (M), ke-3 (P), ke-5 (K). Jawaban: M, P, K.",
                graphicType = GraphicType.LETTER_BUBBLES,
                graphicData = listOf("M", "K", "P", "M", "K", "P")
            ),
            Question(
                id = "l2q5",
                levelId = 2,
                stageId = 5,
                text = "Fokus hanya pada huruf ke-2 sampai ke-4 dari kiri ke kanan pada kelompok berikut!",
                options = listOf("A, B, C", "B, C, D", "C, D, E", "A, C, E"),
                correctAnswerIndex = 1,
                observationTimeSecs = 5,
                explanation = "Kelompok: A(1), B(2), C(3), D(4), E(5). Huruf ke-2 s/d ke-4 adalah B, C, D. Jawaban: B, C, D.",
                graphicType = GraphicType.LETTER_BUBBLES,
                graphicData = listOf("A", "B", "C", "D", "E")
            ),
            Question(
                id = "l2q6",
                levelId = 2,
                stageId = 6,
                text = "Saring pandanganmu! Fokuslah hanya pada semua huruf yang diletakkan setelah huruf P!",
                options = listOf("P, Q, R", "Q, R, S", "Q, R, S, T", "R, S, T"),
                correctAnswerIndex = 2,
                observationTimeSecs = 5,
                explanation = "Deretan: P, Q, R, S, T. Huruf-huruf di kanan huruf P adalah Q, R, S, T.",
                graphicType = GraphicType.LETTER_BUBBLES,
                graphicData = listOf("P", "Q", "R", "S", "T")
            ),
            Question(
                id = "l2q7",
                levelId = 2,
                stageId = 7,
                text = "Fokuslah dan sebutkan hanya huruf-huruf yang terletak di sebelah kiri sebelum huruf O!",
                options = listOf("K, L, M", "L, M, N", "K, L, M, N", "M, N, O"),
                correctAnswerIndex = 2,
                observationTimeSecs = 5,
                explanation = "Deretan: K, L, M, N, O. Huruf sebelum O adalah K, L, M, N. Jawaban: K, L, M, N.",
                graphicType = GraphicType.LETTER_BUBBLES,
                graphicData = listOf("K", "L", "M", "N", "O")
            ),
            Question(
                id = "l2q8",
                levelId = 2,
                stageId = 8,
                text = "Tentukan dan fokuslah hanya pada satu huruf yang posisinya berada tepat di tengah-tengah deretan!",
                options = listOf("C", "E", "G", "I"),
                correctAnswerIndex = 1,
                observationTimeSecs = 5,
                explanation = "Deretan: A, C, E, G, I (total 5 huruf). Huruf tengah ke-3 adalah E. Jawaban: E.",
                graphicType = GraphicType.LETTER_BUBBLES,
                graphicData = listOf("A", "C", "E", "G", "I")
            ),
            Question(
                id = "l2q9",
                levelId = 2,
                stageId = 9,
                text = "Pilihlah dua huruf yang menempati posisi terakhir pada deretan huruf berikut!",
                options = listOf("O, P", "P, Q", "N, O", "M, N"),
                correctAnswerIndex = 1,
                observationTimeSecs = 5,
                explanation = "Deretan: M, N, O, P, Q. Dua huruf terakhir di sebelah kanan adalah P, Q. Jawaban: P, Q.",
                graphicType = GraphicType.LETTER_BUBBLES,
                graphicData = listOf("M", "N", "O", "P", "Q")
            ),
            Question(
                id = "l2q10",
                levelId = 2,
                stageId = 10,
                text = "Seleksi fokusmu! Sebutkan kombinasi dari huruf ke-1 dan huruf ke-5 dalam deretan berikut!",
                options = listOf("B, D", "B, J", "D, J", "F, H"), // Correct is B & J, let's keep index 1 as correct B, J
                correctAnswerIndex = 1,
                observationTimeSecs = 5,
                explanation = "Deretan: B(1), D(2), F(3), H(4), J(5). Huruf ke-1 adalah B, huruf ke-5 adalah J. Jawaban: B, J.",
                graphicType = GraphicType.LETTER_BUBBLES,
                graphicData = listOf("B", "D", "F", "H", "J")
            ),

            // ==================== LEVEL 3 (Spatial Memory, Observation: 6s) ====================
            Question(
                id = "l3q1",
                levelId = 3,
                stageId = 1,
                text = "Ingat posisi benda di halaman kampus! Dimana letak mobil perak berada?",
                options = listOf(
                    "Di sebelah kiri depan gedung",
                    "Di sebelah kanan dekat bus",
                    "Di belakang pohon dekat trotoar",
                    "Di belakang bus dekat halte"
                ),
                correctAnswerIndex = 0,
                observationTimeSecs = 6,
                explanation = "Mobil perak diparkir di sisi paling kiri jalan di depan gedung utama kampus. Jawaban: Di sebelah kiri depan gedung.",
                graphicType = GraphicType.SPATIAL_CAMPUS,
                graphicData = listOf("Gedung", "Mobil_Kiri", "Motor_Tengah", "Bus_Kanan")
            ),
            Question(
                id = "l3q2",
                levelId = 3,
                stageId = 2,
                text = "Ingat posisi benda di meja kerja! Dimanakah letak botol air minum ditempatkan?",
                options = listOf(
                    "Di atas meja dekat kursi",
                    "Di depan laptop dekat mouse",
                    "Di atas meja dekat laptop",
                    "Di kanan laptop dekat buku"
                ),
                correctAnswerIndex = 2,
                observationTimeSecs = 6,
                explanation = "Botol air biru diletakkan berdiri di atas meja utama, tepat di sebelah kiri laptop. Jawaban: Di atas meja dekat laptop.",
                graphicType = GraphicType.SPATIAL_OFFICE,
                graphicData = listOf("Botol_Kiri", "Laptop_Tengah", "Mouse_Kanan")
            ),
            Question(
                id = "l3q3",
                levelId = 3,
                stageId = 3,
                text = "Ingatlah posisi benda di meja belajar! Dimanakah posisi buku catatan diletakkan?",
                options = listOf(
                    "Di sebelah kanan laptop",
                    "Di sebelah kiri laptop",
                    "Di belakang laptop",
                    "Di depan laptop"
                ),
                correctAnswerIndex = 1,
                observationTimeSecs = 6,
                explanation = "Buku catatan tebal diletakkan mendatar di sisi sebelah kiri laptop. Jawaban: Di sebelah kiri laptop.",
                graphicType = GraphicType.SPATIAL_OFFICE,
                graphicData = listOf("Buku_Kiri", "Laptop_Tengah", "Tanaman_Kanan")
            ),
            Question(
                id = "l3q4",
                levelId = 3,
                stageId = 4,
                text = "Ingat susunan taman! Objek apa yang diparkir tepat di sebelah kanan pohon rindang?",
                options = listOf("Bangku", "Gedung", "Sepeda", "Lampu"),
                correctAnswerIndex = 2,
                observationTimeSecs = 6,
                explanation = "Sebelah kiri pohon ada bangku taman, sedangkan di sebelah kanan pohon diparkir sebuah Sepeda.",
                graphicType = GraphicType.SPATIAL_PARK,
                graphicData = listOf("Bangku_Kiri", "Pohon_Tengah", "Sepeda_Kanan")
            ),
            Question(
                id = "l3q5",
                levelId = 3,
                stageId = 5,
                text = "Ingat letak kendaraan di tempat parkir! Di manakah posisi sepeda motor diparkir?",
                options = listOf(
                    "Di kiri mobil dekat trotoar",
                    "Di antara mobil dan bus",
                    "Di belakang bus dekat area parkir",
                    "Di depan bus dekat mobil"
                ),
                correctAnswerIndex = 1,
                observationTimeSecs = 6,
                explanation = "Sepeda motor hitam diparkir di garis tengah, terapit di antara mobil putih (kiri) dan bus pariwisata (kanan).",
                graphicType = GraphicType.SPATIAL_PARKING,
                graphicData = listOf("Mobil_Kiri", "Motor_Tengah", "Bus_Kanan")
            ),
            Question(
                id = "l3q6",
                levelId = 3,
                stageId = 6,
                text = "Ingat tata letak ruang kelas! Objek apa yang dipasang di sisi sebelah kanan papan tulis?",
                options = listOf("Rak Buku", "Jam", "Pintu", "Jendela"),
                correctAnswerIndex = 2,
                observationTimeSecs = 6,
                explanation = "Kanan papan tulis utama terdapat kusen Pintu keluar kelas. Jawaban: Pintu.",
                graphicType = GraphicType.SPATIAL_CLASSROOM,
                graphicData = listOf("Meja_Guru", "PapanTulis", "Pintu_Kanan")
            ),
            Question(
                id = "l3q7",
                levelId = 3,
                stageId = 7,
                text = "Ingatlah suasana meja perpustakaan! Di manakah posisi lampu meja membaca ditempatkan?",
                options = listOf("Di kiri rak", "Di kanan meja", "Di depan rak", "Di atas meja"),
                correctAnswerIndex = 1,
                observationTimeSecs = 6,
                explanation = "Lampu baca berdiri di lantai atau meja di sisi paling kanan dari rangkaian meja membaca kayu.",
                graphicType = GraphicType.SPATIAL_LIBRARY,
                graphicData = listOf("Rak_Kiri", "Meja_Tengah", "Lampu_Kanan")
            ),
            Question(
                id = "l3q8",
                levelId = 3,
                stageId = 8,
                text = "Ingat posisi meja kerja! Objek apa yang letaknya berada paling jauh di sebelah kanan laptop?",
                options = listOf("Buku", "Mouse", "Hiasan Tanaman", "Meja"),
                correctAnswerIndex = 2,
                observationTimeSecs = 6,
                explanation = "Urutan dari kiri: Buku (kiri), Laptop (tengah), Mouse (kanan), dan Hiasan Tanaman pot hijau (paling kanan, terjauh).",
                graphicType = GraphicType.SPATIAL_OFFICE,
                graphicData = listOf("Buku_Kiri", "Laptop_Tengah", "Mouse_Kanan", "Tanaman_KananJauh")
            ),
            Question(
                id = "l3q9",
                levelId = 3,
                stageId = 9,
                text = "Ingat posisi di restoran! Objek apa yang berada paling dekat dengan meja makan pada sisi belakang ruangan?",
                options = listOf("Kasir", "Dapur", "Kursi", "Pintu"),
                correctAnswerIndex = 1,
                observationTimeSecs = 6,
                explanation = "Sisi belakang meja makan menyatu langsung dengan area Dapur terbuka (Kasir ada di depan-kiri). Jawaban: Dapur.",
                graphicType = GraphicType.SPATIAL_DINER,
                graphicData = listOf("Kasir_DepanKiri", "MejaMakan_Tengah", "Dapur_Belakang")
            ),
            Question(
                id = "l3q10",
                levelId = 3,
                stageId = 10,
                text = "Ingat letak luar ruangan parkir motor! Di manakah posisi pohon peneduh tumbuh?",
                options = listOf(
                    "Di belakang motor dan mobil",
                    "Di depan bus dan dekat area parkir",
                    "Di kanan mobil dekat trotoar",
                    "Di kiri motor dekat lampu jalan"
                ),
                correctAnswerIndex = 0,
                observationTimeSecs = 6,
                explanation = "Dinding belakang membatasi lahan parkir motor dan mobil, di mana barisan pohon peneduh hijau tumbuh rindang di balik mereka.",
                graphicType = GraphicType.SPATIAL_PARKING,
                graphicData = listOf("Motor_Kiri", "Mobil_Kanan", "Pohon_Belakang")
            )
        )
    }
}
