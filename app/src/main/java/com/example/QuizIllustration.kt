package com.example

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun QuizIllustration(
    question: Question,
    isVisible: Boolean,
    modifier: Modifier = Modifier
) {
    if (!isVisible) {
        // Render a gorgeous Recall Memory state placeholder
        Box(
            modifier = modifier
                .fillMaxWidth()
                .height(200.dp)
                .clip(RoundedCornerShape(24.dp))
                .background(
                    Brush.linearGradient(
                        colors = listOf(
                            Color(0xFFF7F2FA),
                            Color(0xFFE8DEF8)
                        )
                    )
                )
                .border(1.5.dp, Color(0xFF6750A4), RoundedCornerShape(24.dp)),
            contentAlignment = Alignment.Center
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center,
                modifier = Modifier.padding(16.dp)
            ) {
                // Large mysterious brain glow
                Text(
                    text = "🧠✨",
                    fontSize = 50.sp,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                Text(
                    text = "RECALL MEMORY",
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF6750A4),
                    letterSpacing = 2.sp
                )
                Text(
                    text = "Sebutkan jawabannya berdasarkan memori visualmu!",
                    fontSize = 12.sp,
                    color = Color(0xFF49454F),
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(top = 4.dp)
                )
            }
        }
        return;
    }

    // Wrap the active graphic inside a beautiful presentation card
    Card(
        modifier = modifier
            .fillMaxWidth()
            .height(200.dp)
            .border(1.5.dp, Color(0xFFE1E2EC), RoundedCornerShape(24.dp)),
        shape = RoundedCornerShape(24.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color(0xFF1E1B3E)
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(12.dp),
            contentAlignment = Alignment.Center
        ) {
            when (question.graphicType) {
                GraphicType.EMOJI_ROW -> {
                    EmojiRowIllustration(question.graphicData)
                }
                GraphicType.GEOMETRIC_NUMBERS -> {
                    GeometricNumbersIllustration()
                }
                GraphicType.PLAYLIST_CARDS -> {
                    PlaylistCardsIllustration(question.graphicData)
                }
                GraphicType.SOCIAL_ICONS -> {
                    SocialIconsIllustration()
                }
                GraphicType.TRAFFIC_LIGHTS -> {
                    TrafficLightsIllustration()
                }
                GraphicType.WHITEBOARD_LETTERS -> {
                    WhiteboardLettersIllustration()
                }
                GraphicType.WOOD_ROOM -> {
                    WoodRoomIllustration()
                }
                GraphicType.POST_IT_NOTES -> {
                    PostItNotesIllustration(question.graphicData)
                }
                GraphicType.LETTER_BUBBLES -> {
                    LetterBubblesIllustration(question.graphicData)
                }
                GraphicType.SPATIAL_CAMPUS -> {
                    SpatialCampusIllustration()
                }
                GraphicType.SPATIAL_OFFICE -> {
                    SpatialOfficeIllustration(question.graphicData)
                }
                GraphicType.SPATIAL_PARK -> {
                    SpatialParkIllustration()
                }
                GraphicType.SPATIAL_PARKING -> {
                    SpatialParkingIllustration(question.graphicData)
                }
                GraphicType.SPATIAL_CLASSROOM -> {
                    SpatialClassroomIllustration()
                }
                GraphicType.SPATIAL_LIBRARY -> {
                    SpatialLibraryIllustration()
                }
                GraphicType.SPATIAL_DINER -> {
                    SpatialDinerIllustration()
                }
            }
        }
    }
}

// 1. Emoji Row (Horizontal grid of emojis)
@Composable
fun EmojiRowIllustration(emojis: List<String>) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        emojis.forEach { emoji ->
            Box(
                modifier = Modifier
                    .size(60.dp)
                    .clip(RoundedCornerShape(16.dp))
                    .background(Color(0xFF2D2A54))
                    .border(1.dp, Color(0xFF423F73), RoundedCornerShape(16.dp)),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = emoji,
                    fontSize = 32.sp
                )
            }
        }
    }
}

// 2. Geometric Cards (Level 1 Q2)
@Composable
fun GeometricNumbersIllustration() {
    Row(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        val pairs = listOf(
            "1" to Color(0xFF8E44AD) to "🌀", // Maze square
            "2" to Color(0xFF2980B9) to "▲", // Triangle
            "3" to Color(0xFF27AE60) to "🌑", // Circle
            "4" to Color(0xFFD35400) to "⛰"  // Peaks
        )

        pairs.forEach { (item, icon) ->
            val (num, color) = item
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center,
                modifier = Modifier
                    .width(44.dp)
                    .height(80.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(color.copy(alpha = 0.25f))
                    .border(2.dp, color, RoundedCornerShape(12.dp))
            ) {
                Text(
                    text = num,
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White,
                    modifier = Modifier.padding(bottom = 6.dp)
                )
                Text(
                    text = icon,
                    fontSize = 20.sp,
                    color = color
                )
            }
        }
    }
}

// 3. Simulated Playlist Music Albums (Level 1 Q5)
@Composable
fun PlaylistCardsIllustration(songs: List<String>) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        val colors = listOf(
            Color(0xFF2C3E50), // Akad
            Color(0xFF16A085), // Teman Hidup
            Color(0xFF8E44AD), // Kita Bikin Romantis
            Color(0xFFE74C3C)  // Bermuara
        )
        val singers = listOf("P. Teduh", "Tulus", "Maliq", "R. Febian")

        songs.forEachIndexed { idx, name ->
            val color = colors[idx % colors.size]
            val singer = singers[idx % singers.size]
            Column(
                modifier = Modifier
                    .width(68.dp)
                    .height(110.dp)
                    .clip(RoundedCornerShape(10.dp))
                    .background(color)
                    .border(1.dp, Color.White.copy(alpha = 0.3f), RoundedCornerShape(10.dp))
                    .padding(4.dp),
                verticalArrangement = Arrangement.SpaceBetween,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // Mini CD disc record mockup
                Box(
                    modifier = Modifier
                        .size(36.dp)
                        .clip(CircleShape)
                        .background(Color.Black),
                    contentAlignment = Alignment.Center
                ) {
                    Box(
                        modifier = Modifier
                            .size(12.dp)
                            .clip(CircleShape)
                            .background(Color.White)
                    )
                }
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(
                        text = name,
                        fontSize = 8.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White,
                        textAlign = TextAlign.Center,
                        maxLines = 2,
                        lineHeight = 9.sp
                    )
                    Text(
                        text = singer,
                        fontSize = 7.sp,
                        color = Color.White.copy(alpha = 0.6f),
                        textAlign = TextAlign.Center,
                        maxLines = 1
                    )
                }
                Text(
                    text = "▶",
                    fontSize = 8.sp,
                    color = Color.White
                )
            }
        }
    }
}

// 4. Custom Social Branding Icons (Level 1 Q6)
@Composable
fun SocialIconsIllustration() {
    Row(
        horizontalArrangement = Arrangement.spacedBy(14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Instagram
        Box(
            modifier = Modifier
                .size(45.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(
                    Brush.radialGradient(
                        colors = listOf(Color(0xFFFEC564), Color(0xFFFD5C63), Color(0xFFA12C99))
                    )
                ),
            contentAlignment = Alignment.Center
        ) {
            Text("📸", fontSize = 24.sp)
        }

        // Tiktok
        Box(
            modifier = Modifier
                .size(45.dp)
                .clip(CircleShape)
                .background(Color.Black)
                .border(1.5.dp, Color(0xFF00F2FE), CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Text("🎵", fontSize = 24.sp)
        }

        // WhatsApp
        Box(
            modifier = Modifier
                .size(45.dp)
                .clip(CircleShape)
                .background(Color(0xFF25D366)),
            contentAlignment = Alignment.Center
        ) {
            Text("💬", fontSize = 24.sp)
        }

        // Facebook
        Box(
            modifier = Modifier
                .size(45.dp)
                .clip(CircleShape)
                .background(Color(0xFF1877F2)),
            contentAlignment = Alignment.Center
        ) {
            Text(
                "f",
                fontSize = 26.sp,
                color = Color.White,
                fontWeight = FontWeight.ExtraBold,
                textAlign = TextAlign.Center
            )
        }
    }
}

// 5. Lightpoles Traffic Lights (Level 1 Q9)
@Composable
fun TrafficLightsIllustration() {
    Row(
        horizontalArrangement = Arrangement.spacedBy(28.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        val lightConfigs = listOf(
            Color.Red to "Merah Active",
            Color.Yellow to "Kuning Active",
            Color.Green to "Hijau Active"
        )

        lightConfigs.forEachIndexed { i, (activeColor, _) ->
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                // Pole structure
                Column(
                    modifier = Modifier
                        .width(22.dp)
                        .height(60.dp)
                        .clip(RoundedCornerShape(6.dp))
                        .background(Color(0xFF34495E))
                        .border(1.5.dp, Color(0xFF2C3E50), RoundedCornerShape(6.dp))
                        .padding(vertical = 4.dp),
                    verticalArrangement = Arrangement.SpaceBetween,
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    // Top bulb
                    Box(
                        modifier = Modifier
                            .size(12.dp)
                            .clip(CircleShape)
                            .background(if (i == 0) Color.Red else Color.Red.copy(alpha = 0.15f))
                    )
                    // Middle bulb
                    Box(
                        modifier = Modifier
                            .size(12.dp)
                            .clip(CircleShape)
                            .background(if (i == 1) Color.Yellow else Color.Yellow.copy(alpha = 0.15f))
                    )
                    // Bottom bulb
                    Box(
                        modifier = Modifier
                            .size(12.dp)
                            .clip(CircleShape)
                            .background(if (i == 2) Color.Green else Color.Green.copy(alpha = 0.15f))
                    )
                }
                // Tall stand pole
                Box(
                    modifier = Modifier
                        .width(4.dp)
                        .height(20.dp)
                        .background(Color(0xFF7F8C8D))
                )
            }
        }
    }
}

// 6. Whiteboard Classroom Letters (Level 2 Q1)
@Composable
fun WhiteboardLettersIllustration() {
    Box(
        modifier = Modifier
            .fillMaxWidth(0.85f)
            .height(110.dp)
            .clip(RoundedCornerShape(8.dp))
            .background(Color(0xFF1E3F20)) // Dark Chalkboard Green
            .border(6.dp, Color(0xFF8E6E53), RoundedCornerShape(8.dp)), // Wood border
        contentAlignment = Alignment.Center
    ) {
        Box(modifier = Modifier.fillMaxSize()) {
            // Chalk letters
            Text(
                text = "M",
                fontSize = 26.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFFE74C3C), // Chalk red
                modifier = Modifier
                    .align(Alignment.TopCenter)
                    .padding(top = 10.dp)
            )

            Text(
                text = "K",
                fontSize = 26.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFFE74C3C), // Chalk red
                modifier = Modifier
                    .align(Alignment.BottomStart)
                    .padding(start = 24.dp, bottom = 12.dp)
            )

            Text(
                text = "P",
                fontSize = 26.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFFE74C3C), // Chalk red
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .padding(end = 24.dp, bottom = 12.dp)
            )
        }
    }
}

// 7. Wood Elements Classroom (Level 2 Q2)
@Composable
fun WoodRoomIllustration() {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(120.dp)
    ) {
        // Draw floor perspective
        val wallY = size.height * 0.4f
        drawRect(
            color = Color(0xFF2C3E50),
            size = Size(size.width, wallY)
        )
        // Classroom wooden floorboard lines
        drawRect(
            color = Color(0xFFBDC3C7),
            topLeft = Offset(0f, wallY),
            size = Size(size.width, size.height - wallY)
        )

        // Draw wooden desk
        val deskW = 120f
        val deskH = 65f
        val deskX = (size.width - deskW) / 2
        val deskY = (size.height - deskH) - 10f

        // Desk top (wooden color)
        drawRoundRect(
            color = Color(0xFFD35400),
            topLeft = Offset(deskX, deskY),
            size = Size(deskW, 14f),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(4f)
        )
        // Desk metal legs
        drawLine(
            color = Color(0xFF7F8C8D),
            start = Offset(deskX + 15f, deskY + 12f),
            end = Offset(deskX + 15f, deskY + deskH),
            strokeWidth = 4f
        )
        drawLine(
            color = Color(0xFF7F8C8D),
            start = Offset(deskX + deskW - 15f, deskY + 12f),
            end = Offset(deskX + deskW - 15f, deskY + deskH),
            strokeWidth = 4f
        )

        // Draw wooden chair
        val chairX = deskX - 70f
        val chairY = deskY + 14f
        // Back support
        drawRect(
            color = Color(0xFFE67E22),
            topLeft = Offset(chairX, chairY - 26f),
            size = Size(35f, 6f)
        )
        drawLine(
            color = Color(0xFF7F8C8D),
            start = Offset(chairX + 5f, chairY - 20f),
            end = Offset(chairX + 5f, chairY + 25f),
            strokeWidth = 3f
        )
        drawLine(
            color = Color(0xFF7F8C8D),
            start = Offset(chairX + 30f, chairY - 20f),
            end = Offset(chairX + 30f, chairY + 25f),
            strokeWidth = 3f
        )
        // Seat
        drawRoundRect(
            color = Color(0xFFD35400),
            topLeft = Offset(chairX - 2f, chairY - 2f),
            size = Size(40f, 6f)
        )
        // Legs
        drawLine(
            color = Color(0xFF7F8C8D),
            start = Offset(chairX + 5f, chairY + 4f),
            end = Offset(chairX + 5f, chairY + 36f),
            strokeWidth = 3f
        )
        drawLine(
            color = Color(0xFF7F8C8D),
            start = Offset(chairX + 30f, chairY + 4f),
            end = Offset(chairX + 30f, chairY + 36f),
            strokeWidth = 3f
        )
    }
}

// 8. Overlapping Post-it Memo Notes (Level 2 Q3)
@Composable
fun PostItNotesIllustration(numbers: List<String>) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        val backgrounds = listOf(
            Color(0xFF3498DB), // Blue
            Color(0xFFE91E63), // Pink
            Color(0xFFF1C40F), // Yellow
            Color(0xFFE67E22), // Orange
            Color(0xFF9E7E63), // Brownish
            Color(0xFF2ECC71)  // Mint
        )

        numbers.forEachIndexed { i, num ->
            val color = backgrounds[i % backgrounds.size]
            val isEven = num.toIntOrNull()?.let { it % 2 == 0 } ?: false
            
            Box(
                modifier = Modifier
                    .size(42.dp)
                    .clip(RoundedCornerShape(4.dp))
                    .background(color)
                    .border(
                        if (isEven) 2.dp else 0.dp,
                        if (isEven) Color.White else Color.Transparent,
                        RoundedCornerShape(4.dp)
                    ),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = num,
                    fontSize = 18.sp,
                    fontWeight = FontWeight.ExtraBold,
                    color = Color.White
                )
            }
        }
    }
}

// 9. Letter Bubble rows (Level 2 remaining Qs)
@Composable
fun LetterBubblesIllustration(letters: List<String>) {
    Row(
        horizontalArrangement = Arrangement.spacedBy(10.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        val bubbleColors = listOf(
            Color(0xFF1ABC9C),
            Color(0xFF9B59B6),
            Color(0xFF34495E),
            Color(0xFFE67E22),
            Color(0xFFF1C40F)
        )

        letters.forEachIndexed { i, letter ->
            val color = bubbleColors[i % bubbleColors.size]
            Box(
                modifier = Modifier
                    .size(44.dp)
                    .clip(CircleShape)
                    .background(color)
                    .border(1.dp, Color.White.copy(alpha = 0.5f), CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = letter,
                    fontSize = 19.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                )
            }
        }
    }
}

// 10. Spatial Campus Layout Illustration (Level 3 Q1)
@Composable
fun SpatialCampusIllustration() {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(130.dp)
    ) {
        // Draw grey classroom university back wall block
        val wallH = 65f
        drawRect(
            color = Color(0xFF7F8C8D),
            size = Size(size.width, wallH)
        )
        // Building windows mockup
        for (x in 20..size.width.toInt() step 60) {
            drawRoundRect(
                color = Color.White.copy(alpha = 0.8f),
                topLeft = Offset(x.toFloat(), 15f),
                size = Size(35f, 35f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(4f)
            )
        }

        // Draw street segment in front
        val roadY = wallH
        val roadH = size.height - wallH
        drawRect(
            color = Color(0xFF2C3E50),
            topLeft = Offset(0f, roadY),
            size = Size(size.width, roadH)
        )
        // Road yellow dashed line
        drawLine(
            color = Color.Yellow,
            start = Offset(0f, roadY + roadH / 2),
            end = Offset(size.width, roadY + roadH / 2),
            strokeWidth = 3f,
            pathEffect = androidx.compose.ui.graphics.PathEffect.dashPathEffect(floatArrayOf(20f, 15f))
        )

        // Vehicles on canvas
        // 1. Silver Car (Kiri / Left)
        val carX = 40f
        val carY = roadY + 12f
        drawRoundRect(
            color = Color(0xFFBDC3C7), // Silver/light grey car body
            topLeft = Offset(carX, carY),
            size = Size(65f, 25f),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(6f)
        )
        // Car windows/windshield overlay
        drawRect(
            color = Color(0xFF34495E),
            topLeft = Offset(carX + 12f, carY + 3f),
            size = Size(40f, 19f)
        )

        // 2. Black Scooter/Motorcycle (Tengah / Middle)
        val scooterX = size.width / 2.2f
        val scooterY = roadY + 8f
        // Scooter body
        drawRoundRect(
            color = Color(0xFFE74C3C), // Small red scooter shell
            topLeft = Offset(scooterX, scooterY + 6f),
            size = Size(30f, 15f),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(4f)
        )
        // Black wheels
        drawCircle(color = Color.Black, radius = 5.5f, center = Offset(scooterX + 5f, scooterY + 22f))
        drawCircle(color = Color.Black, radius = 5.5f, center = Offset(scooterX + 25f, scooterY + 22f))

        // 3. Red Bus (Kanan / Right)
        val busX = size.width - 130f
        val busY = roadY + 5f
        drawRoundRect(
            color = Color(0xFFC0392B), // Deep red tourist bus
            topLeft = Offset(busX, busY),
            size = Size(100f, 35f),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(5f)
        )
        // Bus glass strips
        for (bx in 0..4) {
            drawRect(
                color = Color(0xFFECF0F1),
                topLeft = Offset(busX + 6f + bx * 18f, busY + 5f),
                size = Size(12f, 12f)
            )
        }
    }
}

// 11. Spatial Office Workstation Desk (Level 3 Q2, Q3, Q8)
@Composable
fun SpatialOfficeIllustration(elements: List<String>) {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(130.dp)
    ) {
        val deskY = size.height - 35f
        // Draw solid wood table top
        drawRect(
            color = Color(0xFF8E6E53), // Wood brown
            topLeft = Offset(10f, deskY),
            size = Size(size.width - 20f, 15f)
        )
        // Drawer table side support legs
        drawRect(color = Color(0xFF6E5642), topLeft = Offset(20f, deskY + 15f), size = Size(20f, 20f))
        drawRect(color = Color(0xFF6E5642), topLeft = Offset(size.width - 40f, deskY + 15f), size = Size(20f, 20f))

        // Central Laptop (glowing screen)
        val lpW = 85f
        val lpH = 45f
        val lpX = (size.width - lpW) / 2f
        val lpY = deskY - lpH
        // Screen bezel
        drawRoundRect(
            color = Color(0xFF2C3E50),
            topLeft = Offset(lpX, lpY),
            size = Size(lpW, lpH),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(6f)
        )
        // Light shining from display screen
        drawRect(
            color = Color(0xFF5DADE2),
            topLeft = Offset(lpX + 4f, lpY + 4f),
            size = Size(lpW - 8f, lpH - 12f)
        )
        // Laptop base keyboard plate
        drawRect(
            color = Color(0xFF95A5A6),
            topLeft = Offset(lpX - 8f, deskY - 3f),
            size = Size(lpW + 16f, 5f)
        )

        // Draw active dynamic elements:
        // "Botol_Kiri", "Buku_Kiri", "Mouse_Kanan", "Tanaman_Kanan", "Tanaman_KananJauh"
        if (elements.contains("Botol_Kiri")) {
            // Blue water bottle on left desk
            val botX = lpX - 45f
            val botY = deskY - 35f
            drawRoundRect(
                color = Color(0xFF3498DB),
                topLeft = Offset(botX, botY),
                size = Size(12f, 35f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(3f)
            )
            // Cap
            drawRect(color = Color.White, topLeft = Offset(botX + 2f, botY - 4f), size = Size(8f, 4f))
        }

        if (elements.contains("Buku_Kiri")) {
            // Book on left desk
            val bookX = lpX - 60f
            val bookY = deskY - 14f
            drawRoundRect(
                color = Color(0xFF2980B9),
                topLeft = Offset(bookX, bookY),
                size = Size(35f, 14f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(2f)
            )
            // White pages separator line
            drawLine(
                color = Color.White,
                start = Offset(bookX + 5f, bookY + 6f),
                end = Offset(bookX + 30f, bookY + 6f),
                strokeWidth = 2.5f
            )
        }

        if (elements.contains("Mouse_Kanan")) {
            // Compute mouse to the right
            val mX = lpX + lpW + 18f
            val mY = deskY - 8f
            drawRoundRect(
                color = Color.Black,
                topLeft = Offset(mX, mY),
                size = Size(15f, 8f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(4f)
            )
        }

        if (elements.contains("Tanaman_Kanan") || elements.contains("Tanaman_KananJauh")) {
            // Plant pot on right desk side
            val pX = if (elements.contains("Tanaman_KananJauh")) size.width - 65f else lpX + lpW + 45f
            val pY = deskY - 24f
            // Pot
            drawRoundRect(
                color = Color(0xFFE67E22), // Clay orange pot
                topLeft = Offset(pX, pY),
                size = Size(18f, 24f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(2f)
            )
            // Green leaves
            drawCircle(color = Color(0xFF27AE60), radius = 10f, center = Offset(pX + 9f, pY - 6f))
            drawCircle(color = Color(0xFF2ECC71), radius = 8f, center = Offset(pX, pY - 3f))
            drawCircle(color = Color(0xFF2ECC71), radius = 8f, center = Offset(pX + 18f, pY - 3f))
        }
    }
}

// 12. Spatial Park with Bench Tree Bike (Level 3 Q4)
@Composable
fun SpatialParkIllustration() {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(130.dp)
    ) {
        // Soft green park ground
        drawRect(color = Color(0xFF27AE60))

        // Center Tree
        val treeC = Offset(size.width / 2f, size.height - 35f)
        // Trunk
        drawRect(
            color = Color(0xFF7E5109),
            topLeft = Offset(treeC.x - 8f, treeC.y - 45f),
            size = Size(16f, 45f)
        )
        // Green leafy cap
        drawCircle(color = Color(0xFF1E8449), radius = 35f, center = Offset(treeC.x, treeC.y - 55f))
        drawCircle(color = Color(0xFF2E4053).copy(alpha = 0.15f), radius = 35f, center = Offset(treeC.x + 12f, treeC.y + 40f)) // shadow

        // Cozy park bench on left
        val bX = treeC.x - 110f
        val bY = size.height - 40f
        // Seat horizontal slab
        drawRect(color = Color(0xFFBA4A00), topLeft = Offset(bX, bY), size = Size(50f, 6f))
        // Back panel
        drawRect(color = Color(0xFFD35400), topLeft = Offset(bX, bY - 14f), size = Size(50f, 6f))
        // Supports legs
        drawLine(color = Color.Black, start = Offset(bX + 5f, bY), end = Offset(bX + 5f, bY + 18f), strokeWidth = 3f)
        drawLine(color = Color.Black, start = Offset(bX + 45f, bY), end = Offset(bX + 45f, bY + 18f), strokeWidth = 3f)

        // Bicycle on right
        val bkX = treeC.x + 60f
        val bkY = size.height - 25f
        // Wheels
        drawCircle(color = Color.LightGray, radius = 11f, center = Offset(bkX, bkY), style = Stroke(2.5f))
        drawCircle(color = Color.LightGray, radius = 11f, center = Offset(bkX + 38f, bkY), style = Stroke(2.5f))
        drawCircle(color = Color.Black, radius = 12f, center = Offset(bkX, bkY), style = Stroke(1.5f))
        drawCircle(color = Color.Black, radius = 12f, center = Offset(bkX + 38f, bkY), style = Stroke(1.5f))
        // Red triangular frame
        drawLine(color = Color.Red, start = Offset(bkX, bkY), end = Offset(bkX + 18f, bkY - 16f), strokeWidth = 3f)
        drawLine(color = Color.Red, start = Offset(bkX + 38f, bkY), end = Offset(bkX + 18f, bkY - 16f), strokeWidth = 3f)
        drawLine(color = Color.Red, start = Offset(bkX, bkY), end = Offset(bkX + 38f, bkY), strokeWidth = 3f)
        // Handlebars
        drawLine(color = Color.DarkGray, start = Offset(bkX + 38f, bkY), end = Offset(bkX + 36f, bkY - 22f), strokeWidth = 2.5f)
        drawLine(color = Color.Black, start = Offset(bkX + 32f, bkY - 22f), end = Offset(bkX + 42f, bkY - 22f), strokeWidth = 3f)
    }
}

// 13. Parking Spots Visualizer (Level 3 Q5, Q10)
@Composable
fun SpatialParkingIllustration(elements: List<String>) {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(130.dp)
    ) {
        // Grey asphalt
        drawRect(color = Color(0xFF34495E))
        // White partition slots markers
        for (x in listOf(20f, size.width/3f, size.width*2f/3f, size.width - 20f)) {
            drawLine(
                color = Color.White,
                start = Offset(x, 15f),
                end = Offset(x, size.height - 15f),
                strokeWidth = 3f
            )
        }

        // Left Element: can be "Mobil_Kiri" (Q5) or "Motor_Kiri" (Q10)
        if (elements.contains("Mobil_Kiri")) {
            val mX = 40f
            val mY = 30f
            // SUV White car top/flat perspective
            drawRoundRect(
                color = Color.White,
                topLeft = Offset(mX, mY),
                size = Size(46f, 70f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(6f)
            )
            // Windshield and rear windows
            drawRect(color = Color(0xFF2C3E50), topLeft = Offset(mX + 4f, mY + 12f), size = Size(38f, 10f))
            drawRect(color = Color(0xFF2C3E50), topLeft = Offset(mX + 4f, mY + 44f), size = Size(38f, 14f))
        } else if (elements.contains("Motor_Kiri")) {
            // Black scooter
            val bX = 50f
            val bY = 40f
            drawRoundRect(
                color = Color.Black,
                topLeft = Offset(bX, bY),
                size = Size(20f, 48f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(4f)
            )
            drawCircle(color = Color.Yellow, radius = 3.5f, center = Offset(bX + 10f, bY + 4f)) // lamp
        }

        // Center / Middle spot: "Motor_Tengah"
        if (elements.contains("Motor_Tengah")) {
            val bX = size.width / 2.2f
            val bY = 42f
            drawRoundRect(
                color = Color(0xFFE74C3C), // Small red motorbike body
                topLeft = Offset(bX, bY),
                size = Size(20f, 45f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(4f)
            )
        }

        // Right spot: "Bus_Kanan" or "Mobil_Kanan"
        if (elements.contains("Bus_Kanan")) {
            val busX = size.width - 95f
            val busY = 22f
            // Big blue tour bus
            drawRoundRect(
                color = Color(0xFF2471A3),
                topLeft = Offset(busX, busY),
                size = Size(65f, 85f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(6f)
            )
            // Panoramic sunroof
            drawRect(color = Color.Black, topLeft = Offset(busX + 8f, busY + 15f), size = Size(49f, 50f))
        } else if (elements.contains("Mobil_Kanan")) {
            // Silver car
            val mX = size.width - 85f
            val mY = 32f
            drawRoundRect(
                color = Color(0xFFBDC3C7),
                topLeft = Offset(mX, mY),
                size = Size(42f, 65f),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(6f)
            )
        }

        // Background boundary bar with Tree marker "Pohon_Belakang"
        if (elements.contains("Pohon_Belakang")) {
            // Draw background trees at the very top of canvas
            drawRect(
                color = Color(0xFF196F3D),
                topLeft = Offset(0f, 0f),
                size = Size(size.width, 14f)
            )
            for (tx in 30..size.width.toInt() step 50) {
                drawCircle(color = Color(0xFF27AE60), radius = 12f, center = Offset(tx.toFloat(), 4f))
            }
        }
    }
}

// 14. Classroom visualizer (Level 3 Q6)
@Composable
fun SpatialClassroomIllustration() {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(130.dp)
    ) {
        // Ground/Wall partition
        drawRect(color = Color(0xFFBDC3C7)) // Classroom back wall
        
        val fH = size.height * 0.35f
        drawRect(
            color = Color(0xFF7F8C8D),
            topLeft = Offset(0f, size.height - fH),
            size = Size(size.width, fH)
        )

        // Center-Left Whiteboard
        val wbW = 145f
        val wbH = 60f
        val wbX = 50f
        val wbY = 15f
        // Wood frame
        drawRect(color = Color(0xFF8E6E53), topLeft = Offset(wbX, wbY), size = Size(wbW, wbH))
        drawRect(color = Color.White, topLeft = Offset(wbX + 5f, wbY + 5f), size = Size(wbW - 10f, wbH - 10f))

        // Left Podium / Teacher table
        drawRect(
            color = Color(0xFFD35400),
            topLeft = Offset(10f, size.height - 45f),
            size = Size(35f, 35f)
        )

        // Door on right wall
        val drW = 40f
        val drH = 90f
        val drX = size.width - 65f
        val drY = 8f
        // Wooden door outline inside grey wall
        drawRect(color = Color(0xFFBA4A00), topLeft = Offset(drX, drY), size = Size(drW, drH))
        // Brass knob
        drawCircle(color = Color(0xFFF1C40F), radius = 3.5f, center = Offset(drX + 8f, drY + drH/2))
    }
}

// 15. Cozy library visuals (Level 3 Q7)
@Composable
fun SpatialLibraryIllustration() {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(130.dp)
    ) {
        // Floor
        drawRect(color = Color(0xFF5D6D7E))

        // Bookshelf far left back
        val bsW = 75f
        val bsH = 100f
        val bsX = 20f
        val bsY = 10f
        drawRect(color = Color(0xFF7E5109), topLeft = Offset(bsX, bsY), size = Size(bsW, bsH)) // bookshelf skeleton
        // Book contents
        for (row in 0..2) {
            val rY = bsY + 10f + row * 28f
            drawRect(color = Color(0xFF4A3403), topLeft = Offset(bsX + 6f, rY + 18f), size = Size(bsW - 12f, 4f)) // Shelf line
            // Mini colored book rectangles
            drawRect(color = Color.Red, topLeft = Offset(bsX + 12f, rY), size = Size(10f, 18f))
            drawRect(color = Color.Blue, topLeft = Offset(bsX + 24f, rY + 2f), size = Size(8f, 16f))
            drawRect(color = Color.Green, topLeft = Offset(bsX + 34f, rY - 1f), size = Size(12f, 19f))
            drawRect(color = Color.Yellow, topLeft = Offset(bsX + 48f, rY + 4f), size = Size(9f, 14f))
        }

        // Long Study desk (table center-right)
        val tW = 150f
        val tH = 35f
        val tX = size.width - 180f
        val tY = size.height - 45f
        drawRoundRect(
            color = Color(0xFFBA4A00),
            topLeft = Offset(tX, tY),
            size = Size(tW, 12f),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(2f)
        )
        // Table support legs
        drawRect(color = Color(0xFF7E5109), topLeft = Offset(tX + 15f, tY + 12f), size = Size(8f, 23f))
        drawRect(color = Color(0xFF7E5109), topLeft = Offset(tX + tW - 23f, tY + 12f), size = Size(8f, 23f))

        // Floor Stand lamp on the right side of the desk!
        val lpX = tX + tW + 15f
        val lpY = size.height - 95f
        // Vertical lamp stick stands
        drawLine(color = Color.LightGray, start = Offset(lpX, lpY), end = Offset(lpX, size.height - 10f), strokeWidth = 3f)
        // Round solid base
        drawRoundRect(color = Color.Gray, topLeft = Offset(lpX - 12f, size.height - 14f), size = Size(24f, 6f))
        // Gilded shade cap
        val shadePath = Path().apply {
            moveTo(lpX - 16f, lpY + 20f)
            lineTo(lpX + 16f, lpY + 20f)
            lineTo(lpX + 8f, lpY)
            lineTo(lpX - 8f, lpY)
            close()
        }
        drawPath(path = shadePath, color = Color(0xFFF39C12))
        // Simulated warm light glow on desktop surface
        drawCircle(
            color = Color(0xFFF1C40F).copy(alpha = 0.25f),
            radius = 28f,
            center = Offset(lpX, lpY + 35f)
        )
    }
}

// 16. Diner restaurant cashier/kitchen placements (Level 3 Q9)
@Composable
fun SpatialDinerIllustration() {
    Canvas(
        modifier = Modifier
            .fillMaxWidth()
            .height(130.dp)
    ) {
        // Floor grid
        drawRect(color = Color(0xFFE5E7E9))

        // Left front Cashier desk: "Kasir"
        val kX = 20f
        val kY = size.height - 65f
        drawRoundRect(
            color = Color(0xFF2C3E50),
            topLeft = Offset(kX, kY),
            size = Size(65f, 50f),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(4f)
        )
        // Mini display register screen
        drawRect(color = Color.Black, topLeft = Offset(kX + 10f, kY + 10f), size = Size(20f, 15f))
        drawRect(color = Color.Green, topLeft = Offset(kX + 12f, kY + 12f), size = Size(16f, 11f)) // cash text green

        // Center dining table
        val dtX = size.width / 2.3f
        val dtY = size.height - 50f
        drawCircle(color = Color(0xFFE67E22), radius = 24f, center = Offset(dtX, dtY)) // tabular top
        drawCircle(color = Color(0xFF5D6D7E), radius = 6f, center = Offset(dtX, dtY)) // base pole

        // Back Kitchen counter labeled "DAPUR"
        val dW = 130f
        val dH = 75f
        val dX = size.width - 150f
        val dY = 12f
        drawRoundRect(
            color = Color(0xFFBDC3C7),
            topLeft = Offset(dX, dY),
            size = Size(dW, dH),
            cornerRadius = androidx.compose.ui.geometry.CornerRadius(5f)
        )
        // Kitchen window opening
        drawRect(
            color = Color(0xFF34495E),
            topLeft = Offset(dX + 15f, dY + 15f),
            size = Size(dW - 30f, dH - 35f)
        )
    }
}

// Integer extension helper for double to float coordinates safely
private fun Int.s() = this.toFloat()
