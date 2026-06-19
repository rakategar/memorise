package com.example

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.*
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.example.ui.theme.MyApplicationTheme
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.random.Random

@Composable
fun App(vm: QuizViewModel) {
    MyApplicationTheme {
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = Color(0xFFFDFCFF)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color(0xFFFDFCFF))
            ) {
                AnimatedNavigationRouter(vm)
            }
        }
    }
}

@Composable
fun AnimatedNavigationRouter(vm: QuizViewModel) {
    val progressList by vm.progressList.collectAsStateWithLifecycle()
    var isIntroLoading by remember { mutableStateOf(true) }

    LaunchedEffect(Unit) {
        delay(1600)
        isIntroLoading = false
    }

    Crossfade(
        targetState = vm.currentScreen,
        animationSpec = tween(durationMillis = 350, easing = EaseInOutQuad),
        label = "RouterScreenTransition"
    ) { screen ->
        when (screen) {
            is Screen.Splash -> {
                if (isIntroLoading) {
                    IntroLoadingScreen()
                } else {
                    SplashScreen(vm = vm, progressList = progressList)
                }
            }
            is Screen.LevelSelect -> {
                LevelSelectScreen(
                    vm = vm,
                    progressList = progressList,
                    onBack = { vm.navigateTo(Screen.Splash) }
                )
            }
            is Screen.StageSelect -> {
                StageSelectScreen(
                    levelId = screen.levelId,
                    vm = vm,
                    progressList = progressList,
                    onBack = { vm.navigateTo(Screen.LevelSelect) }
                )
            }
            is Screen.Gameplay -> {
                GameplayScreen(levelId = screen.levelId, stageId = screen.stageId, vm = vm)
            }
            is Screen.Summary -> {
                SummaryScreen(
                    levelId = screen.levelId,
                    stageId = screen.stageId,
                    isSuccess = screen.isSuccess,
                    stars = screen.stars,
                    timeSpentMs = screen.timeSpentMs,
                    vm = vm
                )
            }
        }
    }
}

@Composable
fun SkyMeadowBackground(content: @Composable BoxScope.() -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFF3897F2),
                        Color(0xFF5DAEF7),
                        Color(0xFF96D5FA),
                        Color(0xFFD6F0FE),
                        Color(0xFFE8F7FF)
                    )
                )
            )
    ) {
        content()
    }
}

@Composable
fun SmilingBrainCharacter(modifier: Modifier = Modifier) {
    Canvas(modifier = modifier) {
        val w = size.width
        val h = size.height

        val pink = Color(0xFFFFC0D9)
        val pinkDark = Color(0xFFF48FB1)

        drawCircle(pinkDark, radius = w * 0.28f, center = Offset(w * 0.35f, h * 0.46f))
        drawCircle(pinkDark, radius = w * 0.28f, center = Offset(w * 0.65f, h * 0.46f))
        drawCircle(pinkDark, radius = w * 0.24f, center = Offset(w * 0.5f, h * 0.32f))
        drawCircle(pinkDark, radius = w * 0.24f, center = Offset(w * 0.5f, h * 0.64f))

        drawCircle(pink, radius = w * 0.26f, center = Offset(w * 0.35f, h * 0.46f))
        drawCircle(pink, radius = w * 0.26f, center = Offset(w * 0.65f, h * 0.46f))
        drawCircle(pink, radius = w * 0.22f, center = Offset(w * 0.5f, h * 0.32f))
        drawCircle(pink, radius = w * 0.22f, center = Offset(w * 0.5f, h * 0.64f))

        drawCircle(pink, radius = w * 0.21f, center = Offset(w * 0.26f, h * 0.54f))
        drawCircle(pink, radius = w * 0.21f, center = Offset(w * 0.74f, h * 0.54f))

        val eyeRadius = w * 0.045f
        val leftEyeC = Offset(w * 0.41f, h * 0.49f)
        val rightEyeC = Offset(w * 0.59f, h * 0.49f)
        drawCircle(Color.Black, radius = eyeRadius, center = leftEyeC)
        drawCircle(Color.Black, radius = eyeRadius, center = rightEyeC)

        drawCircle(Color.White, radius = eyeRadius * 0.4f, center = Offset(leftEyeC.x - eyeRadius * 0.28f, leftEyeC.y - eyeRadius * 0.28f))
        drawCircle(Color.White, radius = eyeRadius * 0.4f, center = Offset(rightEyeC.x - eyeRadius * 0.28f, rightEyeC.y - eyeRadius * 0.28f))

        drawCircle(Color(0xFFE91E63).copy(alpha = 0.4f), radius = w * 0.052f, center = Offset(w * 0.31f, h * 0.57f))
        drawCircle(Color(0xFFE91E63).copy(alpha = 0.4f), radius = w * 0.052f, center = Offset(w * 0.69f, h * 0.57f))

        val smilePath = Path().apply {
            moveTo(w * 0.47f, h * 0.54f)
            quadraticTo(w * 0.5f, h * 0.61f, w * 0.53f, h * 0.54f)
        }
        drawPath(
            path = smilePath,
            color = Color(0xFF2C3E50),
            style = Stroke(width = w * 0.016f, cap = androidx.compose.ui.graphics.StrokeCap.Round)
        )

        val fold1 = Path().apply {
            moveTo(w * 0.25f, h * 0.36f)
            quadraticTo(w * 0.31f, h * 0.33f, w * 0.37f, h * 0.38f)
        }
        drawPath(fold1, pinkDark, style = Stroke(width = w * 0.012f, cap = androidx.compose.ui.graphics.StrokeCap.Round))

        val fold2 = Path().apply {
            moveTo(w * 0.75f, h * 0.36f)
            quadraticTo(w * 0.69f, h * 0.33f, w * 0.63f, h * 0.38f)
        }
        drawPath(fold2, pinkDark, style = Stroke(width = w * 0.012f, cap = androidx.compose.ui.graphics.StrokeCap.Round))
    }
}

@Composable
fun IntroLoadingScreen() {
    var progressVal by remember { mutableStateOf(0f) }

    LaunchedEffect(Unit) {
        val steps = 40
        for (i in 1..steps) {
            delay(35)
            progressVal = i.toFloat() / steps
        }
    }

    SkyMeadowBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding()
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Spacer(modifier = Modifier.height(16.dp))

            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center,
                modifier = Modifier.weight(1f)
            ) {
                val infiniteTransition = rememberInfiniteTransition(label = "IntroPulse")
                val brainScale by infiniteTransition.animateFloat(
                    initialValue = 1f,
                    targetValue = 1.08f,
                    animationSpec = infiniteRepeatable(
                        animation = tween(800, easing = EaseInOutBack),
                        repeatMode = RepeatMode.Reverse
                    ),
                    label = "BrainScale"
                )

                SmilingBrainCharacter(
                    modifier = Modifier
                        .size(165.dp)
                        .scale(brainScale)
                        .padding(bottom = 12.dp)
                )

                Spacer(modifier = Modifier.height(14.dp))

                Box(contentAlignment = Alignment.Center) {
                    Text(
                        text = "MEMORY CHALLENGE",
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Black,
                        color = Color(0xFF1E3A8A).copy(alpha = 0.15f),
                        letterSpacing = 1.2.sp,
                        textAlign = TextAlign.Center,
                        modifier = Modifier.offset(x = 2.dp, y = 3.dp)
                    )
                    Text(
                        text = "MEMORY CHALLENGE",
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Black,
                        color = Color(0xFF1E355E),
                        letterSpacing = 1.2.sp,
                        textAlign = TextAlign.Center
                    )
                }

                Spacer(modifier = Modifier.height(8.dp))

                Box(
                    modifier = Modifier
                        .background(Color(0xFF6366F1), RoundedCornerShape(14.dp))
                        .padding(horizontal = 14.dp, vertical = 6.dp)
                ) {
                    Text(
                        text = "Uji Ingatanmu!",
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                }
            }

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(0.85f),
                    horizontalArrangement = Arrangement.spacedBy(14.dp, Alignment.CenterHorizontally)
                ) {
                    Card(
                        modifier = Modifier
                            .size(72.dp)
                            .border(1.5.dp, Color(0xFFBDD7EE), RoundedCornerShape(18.dp)),
                        colors = CardDefaults.cardColors(containerColor = Color.White),
                        shape = RoundedCornerShape(18.dp),
                        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
                    ) {
                        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                            Text("🌅", fontSize = 28.sp)
                        }
                    }

                    Card(
                        modifier = Modifier
                            .size(72.dp)
                            .border(1.5.dp, Color(0xFFFFD54F), RoundedCornerShape(18.dp)),
                        colors = CardDefaults.cardColors(containerColor = Color(0xFFFFFAED)),
                        shape = RoundedCornerShape(18.dp),
                        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
                    ) {
                        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                            Text("⭐", fontSize = 28.sp)
                        }
                    }

                    Card(
                        modifier = Modifier
                            .size(72.dp)
                            .border(1.5.dp, Color(0xFF81C784), RoundedCornerShape(18.dp)),
                        colors = CardDefaults.cardColors(containerColor = Color(0xFFE8F5E9)),
                        shape = RoundedCornerShape(18.dp),
                        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
                    ) {
                        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                            Text("❓", fontSize = 28.sp)
                        }
                    }
                }

                Spacer(modifier = Modifier.height(26.dp))

                LinearProgressIndicator(
                    progress = { progressVal },
                    modifier = Modifier
                        .fillMaxWidth(0.82f)
                        .height(13.dp)
                        .clip(RoundedCornerShape(8.dp)),
                    color = Color(0xFF3B82F6),
                    trackColor = Color(0xFFE2E8F0)
                )

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = "${(progressVal * 100).toInt()}%",
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Black,
                    color = Color(0xFF475569)
                )
            }
        }
    }
}

@Composable
fun SplashScreen(
    vm: QuizViewModel,
    progressList: List<StageProgress>
) {
    val totalStars = progressList.sumOf { it.starsCount }
    val solvedStages = progressList.count { it.isCompleted }

    var showPanduanDialog by remember { mutableStateOf(false) }
    var showPengaturanDialog by remember { mutableStateOf(false) }
    var showTrophyDialog by remember { mutableStateOf(false) }
    var showStatistikDialog by remember { mutableStateOf(false) }
    var showTokoDialog by remember { mutableStateOf(false) }

    val infiniteTransition = rememberInfiniteTransition(label = "CTAHeartbeat")
    val scale by infiniteTransition.animateFloat(
        initialValue = 1f,
        targetValue = 1.05f,
        animationSpec = infiniteRepeatable(
            animation = tween(1200, easing = EaseInOutSine),
            repeatMode = RepeatMode.Reverse
        ),
        label = "BtnPulse"
    )

    SkyMeadowBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding()
                .verticalScroll(rememberScrollState())
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 12.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(Color.White)
                        .border(1.5.dp, Color(0xFFE2E8F0), RoundedCornerShape(16.dp))
                        .padding(horizontal = 12.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("🧑‍🚀", fontSize = 16.sp)
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = "Player",
                        fontSize = 12.sp,
                        fontWeight = FontWeight.ExtraBold,
                        color = Color(0xFF475569)
                    )
                }

                Row(
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(Color(0xFFFFFAED))
                        .border(1.5.dp, Color(0xFFFFD54F), RoundedCornerShape(16.dp))
                        .padding(horizontal = 12.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("⭐", fontSize = 16.sp)
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(
                        text = "$totalStars",
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Black,
                        color = Color(0xFFB45309)
                    )
                }
            }

            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.padding(vertical = 12.dp)
            ) {
                val brainTransition = rememberInfiniteTransition(label = "MenuBrainPulse")
                val brainScale by brainTransition.animateFloat(
                    initialValue = 0.96f,
                    targetValue = 1.04f,
                    animationSpec = infiniteRepeatable(
                        animation = tween(1500, easing = EaseInOutQuad),
                        repeatMode = RepeatMode.Reverse
                    ),
                    label = "BrainScale"
                )

                SmilingBrainCharacter(
                    modifier = Modifier
                        .size(150.dp)
                        .scale(brainScale)
                )

                Spacer(modifier = Modifier.height(14.dp))

                Box(contentAlignment = Alignment.Center) {
                    Text(
                        text = "MEMORY CHALLENGE",
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Black,
                        color = Color(0xFF1E3A8A).copy(alpha = 0.15f),
                        letterSpacing = 1.2.sp,
                        textAlign = TextAlign.Center,
                        modifier = Modifier.offset(x = 2.dp, y = 3.dp)
                    )
                    Text(
                        text = "MEMORY CHALLENGE",
                        fontSize = 32.sp,
                        fontWeight = FontWeight.Black,
                        color = Color(0xFF1E355E),
                        letterSpacing = 1.2.sp,
                        textAlign = TextAlign.Center
                    )
                }

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = "Uji Ingatanmu!",
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF4F46E5),
                    letterSpacing = 1.sp
                )
            }

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 16.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Button(
                    onClick = { vm.navigateTo(Screen.LevelSelect) },
                    modifier = Modifier
                        .fillMaxWidth(0.9f)
                        .height(60.dp)
                        .scale(scale)
                        .border(2.5.dp, Color(0xFFB45309), RoundedCornerShape(22.dp))
                        .testTag("play_button"),
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFBBF24)),
                    shape = RoundedCornerShape(22.dp),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 4.dp)
                ) {
                    Text(
                        text = "PLAY",
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Black,
                        color = Color(0xFF78350F)
                    )
                }

                Row(
                    modifier = Modifier.fillMaxWidth(0.9f),
                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Button(
                        onClick = {
                            vm.soundManager.playSound(SfxType.CLICK)
                            showPanduanDialog = true
                        },
                        modifier = Modifier
                            .weight(1f)
                            .height(48.dp)
                            .border(1.5.dp, Color(0xFF1E3A8A), RoundedCornerShape(16.dp))
                            .testTag("panduan_button"),
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2563EB)),
                        shape = RoundedCornerShape(16.dp)
                    ) {
                        Text(text = "PANDUAN", fontSize = 13.sp, fontWeight = FontWeight.Black, color = Color.White)
                    }

                    Button(
                        onClick = {
                            vm.soundManager.playSound(SfxType.CLICK)
                            showPengaturanDialog = true
                        },
                        modifier = Modifier
                            .weight(1f)
                            .height(48.dp)
                            .border(1.5.dp, Color(0xFF1E3A8A), RoundedCornerShape(16.dp))
                            .testTag("pengaturan_button"),
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2563EB)),
                        shape = RoundedCornerShape(16.dp)
                    ) {
                        Text(text = "PENGATURAN", fontSize = 13.sp, fontWeight = FontWeight.Black, color = Color.White)
                    }
                }
            }

            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 10.dp),
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                Card(
                    modifier = Modifier
                        .weight(1.0f)
                        .height(82.dp)
                        .border(1.2.dp, Color(0xFFCBD5E1), RoundedCornerShape(16.dp))
                        .clickable {
                            vm.soundManager.playSound(SfxType.CLICK)
                            showTrophyDialog = true
                        },
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    shape = RoundedCornerShape(16.dp)
                ) {
                    Column(modifier = Modifier.fillMaxSize(), verticalArrangement = Arrangement.Center, horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("🏆", fontSize = 24.sp)
                        Text("TROPHY", fontSize = 10.sp, fontWeight = FontWeight.Black, color = Color(0xFF1E3A8A))
                    }
                }

                Card(
                    modifier = Modifier
                        .weight(1.0f)
                        .height(82.dp)
                        .border(1.2.dp, Color(0xFFCBD5E1), RoundedCornerShape(16.dp))
                        .clickable {
                            vm.soundManager.playSound(SfxType.CLICK)
                            showStatistikDialog = true
                        },
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    shape = RoundedCornerShape(16.dp)
                ) {
                    Column(modifier = Modifier.fillMaxSize(), verticalArrangement = Arrangement.Center, horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("📊", fontSize = 24.sp)
                        Text("STATISTIK", fontSize = 10.sp, fontWeight = FontWeight.Black, color = Color(0xFF1E3A8A))
                    }
                }

                Card(
                    modifier = Modifier
                        .weight(1.0f)
                        .height(82.dp)
                        .border(1.2.dp, Color(0xFFCBD5E1), RoundedCornerShape(16.dp))
                        .clickable {
                            vm.soundManager.playSound(SfxType.CLICK)
                            showTokoDialog = true
                        },
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    shape = RoundedCornerShape(16.dp)
                ) {
                    Column(modifier = Modifier.fillMaxSize(), verticalArrangement = Arrangement.Center, horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("🧸", fontSize = 24.sp)
                        Text("TOKO", fontSize = 10.sp, fontWeight = FontWeight.Black, color = Color(0xFF1E3A8A))
                    }
                }
            }
        }
    }

    if (showPanduanDialog) {
        AlertDialog(
            onDismissRequest = { showPanduanDialog = false },
            confirmButton = {
                Button(onClick = { showPanduanDialog = false }, colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF4CAF50)), shape = RoundedCornerShape(12.dp)) {
                    Text("OK, MENGERTI!", fontWeight = FontWeight.Bold, color = Color.White)
                }
            },
            title = {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("💡 ", fontSize = 22.sp)
                    Text("Cara Bermain", fontWeight = FontWeight.Bold, color = Color(0xFF1E3A8A))
                }
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    Row { Text("⚡ 1. ", fontWeight = FontWeight.Bold, color = Color(0xFFE28743)); Text("Amati dan ingat susunan/letak gambar dengan teliti sebelum waktu habis!", color = Color(0xFF334155)) }
                    Row { Text("🧠 2. ", fontWeight = FontWeight.Bold, color = Color(0xFF9B59B6)); Text("Setelah gambar disembunyikan, jawab pertanyaan berdasarkan ingatan visualmu!", color = Color(0xFF334155)) }
                    Row { Text("⭐ 3. ", fontWeight = FontWeight.Bold, color = Color(0xFFF1C40F)); Text("Semakin cepat kamu menjawab dengan benar, semakin banyak BINTANG yang diraih!", color = Color(0xFF334155)) }
                }
            },
            shape = RoundedCornerShape(24.dp),
            containerColor = Color.White
        )
    }

    if (showPengaturanDialog) {
        AlertDialog(
            onDismissRequest = { showPengaturanDialog = false },
            confirmButton = {
                Button(onClick = { showPengaturanDialog = false }, colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2563EB)), shape = RoundedCornerShape(12.dp)) {
                    Text("SELESAI", fontWeight = FontWeight.Bold, color = Color.White)
                }
            },
            title = {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("⚙️ ", fontSize = 22.sp)
                    Text("Pengaturan Game", fontWeight = FontWeight.Bold, color = Color(0xFF1E3A8A))
                }
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(14.dp), modifier = Modifier.fillMaxWidth()) {
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text("🎵  ", fontSize = 16.sp)
                            Text("Musik Background", fontWeight = FontWeight.Bold, color = Color(0xFF334155))
                        }
                        Switch(checked = vm.soundManager.isMusicEnabled, onCheckedChange = { vm.toggleMusic() })
                    }
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text("🔊  ", fontSize = 16.sp)
                            Text("Efek Suara (SFX)", fontWeight = FontWeight.Bold, color = Color(0xFF334155))
                        }
                        Switch(checked = vm.soundManager.isSoundEnabled, onCheckedChange = { vm.toggleSound() })
                    }
                    HorizontalDivider(color = Color(0xFFE2E8F0))
                    Text(text = "MANAJEMEN PROGRESS DATA:", fontSize = 11.sp, fontWeight = FontWeight.Black, color = Color(0xFF4F46E5))
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        OutlinedButton(
                            onClick = { vm.resetGame(); showPengaturanDialog = false },
                            modifier = Modifier.weight(1f),
                            border = BorderStroke(1.5.dp, Color(0xFFEF4444)),
                            shape = RoundedCornerShape(12.dp),
                            colors = ButtonDefaults.outlinedButtonColors(contentColor = Color(0xFFEF4444))
                        ) {
                            Text("Reset Data", fontSize = 11.sp, fontWeight = FontWeight.Bold)
                        }
                        Button(
                            onClick = { vm.unlockAll(); showPengaturanDialog = false },
                            modifier = Modifier.weight(1f),
                            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF6366F1)),
                            shape = RoundedCornerShape(12.dp)
                        ) {
                            Text("Unlock All", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = Color.White)
                        }
                    }
                }
            },
            shape = RoundedCornerShape(24.dp),
            containerColor = Color.White
        )
    }

    if (showTrophyDialog) {
        AlertDialog(
            onDismissRequest = { showTrophyDialog = false },
            confirmButton = {
                Button(onClick = { showTrophyDialog = false }, colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFFD54F)), shape = RoundedCornerShape(12.dp)) {
                    Text("OK!", fontWeight = FontWeight.Bold, color = Color(0xFF78350F))
                }
            },
            title = {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("🏆 ", fontSize = 24.sp)
                    Text("Piala Kejuaraan", fontWeight = FontWeight.Bold, color = Color(0xFFB45309))
                }
            },
            text = {
                Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                    Text("🌟 RAJA MEMORI PINTAR 🌟", fontWeight = FontWeight.Black, color = Color(0xFF78350F), fontSize = 16.sp)
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "Raih bintang terbanyak di semua level untuk menyempurnakan koleksi piala pahlawan memorimu! \n\nKamu sudah meraih $totalStars bintang dari total 90 bintang!",
                        color = Color(0xFF475569), textAlign = TextAlign.Center, lineHeight = 18.sp, fontSize = 13.sp
                    )
                }
            },
            shape = RoundedCornerShape(24.dp),
            containerColor = Color(0xFFFFFAF0)
        )
    }

    if (showStatistikDialog) {
        AlertDialog(
            onDismissRequest = { showStatistikDialog = false },
            confirmButton = {
                Button(onClick = { showStatistikDialog = false }, colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF4CAF50)), shape = RoundedCornerShape(12.dp)) {
                    Text("MANTAP!", fontWeight = FontWeight.Bold, color = Color.White)
                }
            },
            title = {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("📊 ", fontSize = 22.sp)
                    Text("Statistik Bermain", fontWeight = FontWeight.Bold, color = Color(0xFF1E3A8A))
                }
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(10.dp), modifier = Modifier.fillMaxWidth()) {
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("Bintang Terkumpul:", color = Color(0xFF475569))
                        Text("$totalStars / 90 ⭐", fontWeight = FontWeight.Black, color = Color(0xFFE67E22))
                    }
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("Soal Terpecahkan:", color = Color(0xFF475569))
                        Text("$solvedStages / 30 Soal", fontWeight = FontWeight.Black, color = Color(0xFF2ECC71))
                    }
                    val accuracyPercentage = if (solvedStages > 0) ((totalStars.toFloat() / (solvedStages * 3)) * 100).toInt() else 0
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("Predikat Akurasi:", color = Color(0xFF475569))
                        Text("$accuracyPercentage %", fontWeight = FontWeight.Black, color = Color(0xFF3498DB))
                    }
                }
            },
            shape = RoundedCornerShape(24.dp),
            containerColor = Color.White
        )
    }

    if (showTokoDialog) {
        AlertDialog(
            onDismissRequest = { showTokoDialog = false },
            confirmButton = {
                Button(onClick = { showTokoDialog = false }, colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF9B59B6)), shape = RoundedCornerShape(12.dp)) {
                    Text("MULAILAH KUMPULKAN!", fontWeight = FontWeight.Bold, color = Color.White)
                }
            },
            title = {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("🧸 ", fontSize = 24.sp)
                    Text("Toko Mainan", fontWeight = FontWeight.Bold, color = Color(0xFF4A148C))
                }
            },
            text = {
                Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                    Text("🚀 SKIN & MAINAN UNLOCKER 🚀", fontWeight = FontWeight.Black, color = Color(0xFF4A148C), fontSize = 14.sp)
                    Spacer(modifier = Modifier.height(10.dp))
                    Text(
                        text = "Kumpulkan minimal 20 Bintang ⭐ untuk membuka Mainan Alien Hijau Lucu 👽!\n\nKumpulkan minimal 45 Bintang ⭐ untuk membuka Skin Kostum Astronot Super 🧑‍🚀!\n\nProgress saat ini: $totalStars Bintang.",
                        color = Color(0xFF475569), textAlign = TextAlign.Center, lineHeight = 18.sp, fontSize = 13.sp
                    )
                }
            },
            shape = RoundedCornerShape(24.dp),
            containerColor = Color.White
        )
    }
}

@Composable
fun LevelSelectScreen(
    vm: QuizViewModel,
    progressList: List<StageProgress>,
    onBack: () -> Unit
) {
    val totalStars = progressList.sumOf { it.starsCount }

    SkyMeadowBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding()
                .verticalScroll(rememberScrollState())
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Row(
                modifier = Modifier.fillMaxWidth().padding(bottom = 16.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Card(
                    modifier = Modifier.size(46.dp).clickable(onClick = onBack),
                    shape = RoundedCornerShape(14.dp),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    border = BorderStroke(1.2.dp, Color(0xFFE2E8F0)),
                    elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
                ) {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Icon(imageVector = Icons.Filled.ArrowBack, contentDescription = "Back", tint = Color(0xFF1E3A8A), modifier = Modifier.size(20.dp))
                    }
                }

                Text(text = "PILIH LEVEL", fontSize = 20.sp, fontWeight = FontWeight.Black, color = Color(0xFF1E355E), letterSpacing = 1.2.sp)

                Row(
                    modifier = Modifier
                        .clip(RoundedCornerShape(14.dp))
                        .background(Color(0xFFFFFAED))
                        .border(1.2.dp, Color(0xFFFFD54F), RoundedCornerShape(14.dp))
                        .padding(horizontal = 10.dp, vertical = 6.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text("⭐", fontSize = 14.sp)
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(text = "$totalStars", fontSize = 12.sp, fontWeight = FontWeight.Black, color = Color(0xFFB45309))
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            for (lvl in 1..3) {
                val name = QuizQuestions.levelNames[lvl] ?: ""
                val desc = QuizQuestions.levelDescriptions[lvl] ?: ""
                val levelProgress = progressList.filter { it.levelId == lvl }
                val completedCount = levelProgress.count { it.isCompleted }
                val starsCollected = levelProgress.sumOf { it.starsCount }
                val isUnlocked = if (lvl == 1) true
                else progressList.filter { it.levelId == lvl - 1 }.all { it.isCompleted } || levelProgress.any { it.isUnlocked }

                LevelCard(
                    levelId = lvl,
                    name = name,
                    description = desc,
                    completedCount = completedCount,
                    starsCollected = starsCollected,
                    isUnlocked = isUnlocked,
                    onClick = {
                        if (isUnlocked) vm.navigateTo(Screen.StageSelect(lvl))
                        else vm.soundManager.playSound(SfxType.INCORRECT)
                    }
                )
                Spacer(modifier = Modifier.height(16.dp))
            }
        }
    }
}

@Composable
fun LevelCard(
    levelId: Int,
    name: String,
    description: String,
    completedCount: Int,
    starsCollected: Int,
    isUnlocked: Boolean,
    onClick: () -> Unit
) {
    val alpha = if (isUnlocked) 1f else 0.5f
    val accentColor = when (levelId) {
        1 -> Color(0xFF3498DB)
        2 -> Color(0xFF9B59B6)
        else -> Color(0xFFE67E22)
    }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(24.dp))
            .clickable(enabled = isUnlocked, onClick = onClick)
            .border(1.5.dp, if (isUnlocked) accentColor.copy(alpha = 0.5f) else Color(0xFFCAC4D0), RoundedCornerShape(24.dp)),
        colors = CardDefaults.cardColors(containerColor = if (isUnlocked) Color(0xFFFFFFFF) else Color(0xFFF1F0F4)),
        elevation = CardDefaults.cardElevation(defaultElevation = if (isUnlocked) 2.dp else 0.dp)
    ) {
        Row(modifier = Modifier.fillMaxWidth().padding(20.dp), verticalAlignment = Alignment.CenterVertically) {
            Box(
                modifier = Modifier
                    .size(68.dp)
                    .clip(RoundedCornerShape(18.dp))
                    .background(if (isUnlocked) accentColor.copy(alpha = 0.15f) else Color(0xFFE1E2EC)),
                contentAlignment = Alignment.Center
            ) {
                if (isUnlocked) {
                    Text(text = "L$levelId", fontSize = 24.sp, fontWeight = FontWeight.Black, color = accentColor)
                } else {
                    Icon(imageVector = Icons.Filled.Lock, contentDescription = "Locked", tint = Color(0xFF938F99))
                }
            }

            Spacer(modifier = Modifier.width(16.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(text = "LEVEL $levelId", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = accentColor.copy(alpha = alpha), letterSpacing = 1.sp)
                Text(text = name, fontSize = 19.sp, fontWeight = FontWeight.Bold, color = Color(0xFF1C1B1F).copy(alpha = alpha), maxLines = 1, overflow = TextOverflow.Ellipsis)
                Spacer(modifier = Modifier.height(4.dp))
                Text(text = description, fontSize = 11.sp, color = Color(0xFF49454F).copy(alpha = alpha), maxLines = 2, overflow = TextOverflow.Ellipsis, lineHeight = 15.sp)

                if (isUnlocked && completedCount > 0) {
                    Row(modifier = Modifier.padding(top = 10.dp), verticalAlignment = Alignment.CenterVertically) {
                        Icon(imageVector = Icons.Filled.Star, contentDescription = "Stars", tint = Color(0xFFFFD60A), modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(text = "$starsCollected/30 ⭐   |   Tuntas: $completedCount/10 Soal", fontSize = 11.sp, fontWeight = FontWeight.Bold, color = Color(0xFF6750A4))
                    }
                }
            }
        }
    }
}

@Composable
fun StageSelectScreen(
    levelId: Int,
    vm: QuizViewModel,
    progressList: List<StageProgress>,
    onBack: () -> Unit
) {
    val levelName = QuizQuestions.levelNames[levelId] ?: ""
    val levelProgress = progressList.filter { it.levelId == levelId }
    val totalStarsObtained = levelProgress.sumOf { it.starsCount }
    val accentColor = when (levelId) {
        1 -> Color(0xFF3B82F6)
        2 -> Color(0xFF8B5CF6)
        else -> Color(0xFFF97316)
    }

    SkyMeadowBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding()
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Row(
                modifier = Modifier.fillMaxWidth().padding(bottom = 12.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Card(
                    modifier = Modifier.size(46.dp).clickable(onClick = onBack),
                    shape = RoundedCornerShape(14.dp),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    border = BorderStroke(1.2.dp, Color(0xFFE2E8F0)),
                    elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
                ) {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Icon(imageVector = Icons.Filled.ArrowBack, contentDescription = "Back", tint = Color(0xFF1E3A8A), modifier = Modifier.size(20.dp))
                    }
                }
                Text(text = "LEVEL $levelId SOAL MAP", fontSize = 18.sp, fontWeight = FontWeight.Black, color = Color(0xFF1F2937), letterSpacing = 1.2.sp)
                Spacer(modifier = Modifier.size(46.dp))
            }

            Card(
                modifier = Modifier.fillMaxWidth().padding(bottom = 18.dp).border(1.5.dp, Color(0xFFE2E8F0), RoundedCornerShape(22.dp)),
                colors = CardDefaults.cardColors(containerColor = Color.White.copy(alpha = 0.95f)),
                shape = RoundedCornerShape(22.dp),
                elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(text = levelName, fontSize = 20.sp, fontWeight = FontWeight.Black, color = accentColor, textAlign = TextAlign.Center)
                    Text(text = "Kumpulkan bintang untuk membuka kunci level berikutnya!", fontSize = 11.sp, color = Color(0xFF64748B), modifier = Modifier.padding(top = 2.dp), textAlign = TextAlign.Center)
                    Spacer(modifier = Modifier.height(10.dp))
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier
                            .background(Color(0xFFFFFAED), RoundedCornerShape(12.dp))
                            .border(1.dp, Color(0xFFFFD54F), RoundedCornerShape(12.dp))
                            .padding(horizontal = 12.dp, vertical = 6.dp)
                    ) {
                        Icon(imageVector = Icons.Filled.Star, contentDescription = "Stars collected", tint = Color(0xFFFFC107), modifier = Modifier.size(18.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(text = "$totalStarsObtained / 30 Bintang", fontSize = 14.sp, fontWeight = FontWeight.Black, color = Color(0xFFB45309))
                    }
                }
            }

            LazyVerticalGrid(
                columns = GridCells.Fixed(3),
                horizontalArrangement = Arrangement.spacedBy(12.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                modifier = Modifier.weight(1f)
            ) {
                items((1..10).toList()) { stgId ->
                    val progress = levelProgress.firstOrNull { it.stageId == stgId }
                    val isUnlocked = progress?.isUnlocked ?: (stgId == 1 && levelId == 1)
                    val isCompleted = progress?.isCompleted ?: false
                    val stars = progress?.starsCount ?: 0
                    val bestTimeSec = progress?.let { if (it.timeSpentMs > 0) (it.timeSpentMs / 1000f) else null }

                    StageMapNode(
                        stageId = stgId,
                        isUnlocked = isUnlocked,
                        isCompleted = isCompleted,
                        stars = stars,
                        bestTimeSec = bestTimeSec,
                        accentColor = accentColor,
                        onClick = {
                            if (isUnlocked) vm.navigateTo(Screen.Gameplay(levelId, stgId))
                            else vm.soundManager.playSound(SfxType.INCORRECT)
                        }
                    )
                }
            }
        }
    }
}

@Composable
fun StageMapNode(
    stageId: Int,
    isUnlocked: Boolean,
    isCompleted: Boolean,
    stars: Int,
    bestTimeSec: Float?,
    accentColor: Color,
    onClick: () -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
        modifier = Modifier
            .clip(RoundedCornerShape(20.dp))
            .background(if (isUnlocked) Color.White else Color(0xFFF1F5F9).copy(alpha = 0.8f))
            .border(1.5.dp, if (isUnlocked) accentColor.copy(alpha = 0.5f) else Color(0xFFCBD5E1), RoundedCornerShape(20.dp))
            .clickable(enabled = isUnlocked, onClick = onClick)
            .padding(10.dp)
            .testTag("stage_node_${stageId}")
    ) {
        Box(
            modifier = Modifier
                .size(44.dp)
                .clip(CircleShape)
                .background(if (isCompleted) accentColor else if (isUnlocked) accentColor.copy(alpha = 0.12f) else Color(0xFFE2E8F0)),
            contentAlignment = Alignment.Center
        ) {
            if (isUnlocked) {
                Text(text = "$stageId", fontSize = 18.sp, fontWeight = FontWeight.Black, color = if (isCompleted) Color.White else accentColor)
            } else {
                Icon(imageVector = Icons.Filled.Lock, contentDescription = "Locked Stage", tint = Color(0xFF94A3B8), modifier = Modifier.size(16.dp))
            }
        }

        Spacer(modifier = Modifier.height(6.dp))

        Row(horizontalArrangement = Arrangement.Center, verticalAlignment = Alignment.CenterVertically) {
            for (s in 1..3) {
                val clr = if (s <= stars) Color(0xFFFFC107) else Color(0xFFCBD5E1).copy(alpha = 0.5f)
                Icon(imageVector = Icons.Filled.Star, contentDescription = null, tint = clr, modifier = Modifier.size(11.dp))
            }
        }

        if (bestTimeSec != null && isCompleted) {
            Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.padding(top = 4.dp)) {
                Text(
                    text = "⏱️ ${"%.1f".format(bestTimeSec)}s",
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF10B981)
                )
            }
        }
    }
}

@Composable
fun GameplayScreen(
    levelId: Int,
    stageId: Int,
    vm: QuizViewModel
) {
    val q = vm.currentQuestion
    val isObs = vm.isObservationPhase
    val obsTimer = vm.observationTimer
    val ansElapsedMs = vm.answerTimeElapsedMs
    val selectedIdx = vm.selectedOptionIndex

    val accentColor = when (levelId) {
        1 -> Color(0xFF3B82F6)
        2 -> Color(0xFF8B5CF6)
        else -> Color(0xFFF97316)
    }

    if (q == null) return

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFE0F2FE))
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding()
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Card(
                    modifier = Modifier.size(46.dp).clickable { vm.navigateTo(Screen.StageSelect(levelId)) },
                    shape = RoundedCornerShape(14.dp),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    border = BorderStroke(1.2.dp, Color(0xFFCBD5E1)),
                    elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
                ) {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Icon(imageVector = Icons.Filled.Close, contentDescription = "Cancel Quiz", tint = Color(0xFF1E3A8A), modifier = Modifier.size(20.dp))
                    }
                }

                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(16.dp))
                        .background(Color(0xFF1E355E))
                        .padding(horizontal = 14.dp, vertical = 6.dp)
                ) {
                    Text(text = "LEVEL $levelId • SOAL $stageId", fontSize = 12.sp, fontWeight = FontWeight.Black, color = Color.White, letterSpacing = 0.5.sp)
                }

                Spacer(modifier = Modifier.size(46.dp))
            }

            if (isObs) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center,
                    modifier = Modifier.padding(bottom = 8.dp)
                ) {
                    Box(
                        modifier = Modifier
                            .size(76.dp)
                            .clip(CircleShape)
                            .background(Color.White)
                            .border(1.5.dp, Color(0xFFE2E8F0), CircleShape),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator(
                            progress = { obsTimer.toFloat() / q.observationTimeSecs },
                            modifier = Modifier.fillMaxSize(),
                            color = accentColor,
                            strokeWidth = 4.dp,
                            trackColor = Color(0xFFF1F5F9)
                        )
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Text(text = "$obsTimer", fontSize = 26.sp, fontWeight = FontWeight.Black, color = Color(0xFF1E2937))
                            Text(text = "detik", fontSize = 9.sp, fontWeight = FontWeight.Bold, color = Color(0xFF64748B))
                        }
                    }

                    Spacer(modifier = Modifier.height(8.dp))
                    Text(text = "PERHATIKAN & INGAT DETAIL GAMBAR!", fontSize = 11.sp, fontWeight = FontWeight.Black, color = Color(0xFF1E3A8A), letterSpacing = 1.sp)
                }
            } else {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center,
                    modifier = Modifier.padding(bottom = 8.dp)
                ) {
                    val elapsedSec = ansElapsedMs / 1000f
                    val starsGained = when {
                        ansElapsedMs < 3000L -> 3
                        ansElapsedMs < 7000L -> 2
                        else -> 1
                    }

                    Row(
                        modifier = Modifier
                            .background(Color.White, RoundedCornerShape(12.dp))
                            .border(1.2.dp, Color(0xFFCBD5E1), RoundedCornerShape(12.dp))
                            .padding(horizontal = 12.dp, vertical = 6.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("⏱️", fontSize = 16.sp)
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = "${"%.2f".format(elapsedSec)} s",
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Black,
                            color = Color(0xFF1F2937)
                        )
                    }

                    Row(modifier = Modifier.padding(top = 8.dp), horizontalArrangement = Arrangement.Center) {
                        for (st in 1..3) {
                            val active = st <= starsGained
                            Icon(
                                imageVector = Icons.Filled.Star,
                                contentDescription = null,
                                tint = if (active) Color(0xFFFFC107) else Color(0xFFCBD5E1).copy(alpha = 0.5f),
                                modifier = Modifier.size(24.dp).scale(if (active) 1.2f else 1.0f)
                            )
                        }
                    }
                }
            }

            val shouldShowIllustration = if (isObs) true else (levelId == 2)

            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
                    .padding(vertical = 10.dp)
                    .border(1.5.dp, Color(0xFFCBD5E1), RoundedCornerShape(24.dp)),
                colors = CardDefaults.cardColors(containerColor = Color.White),
                shape = RoundedCornerShape(24.dp),
                elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
            ) {
                Box(modifier = Modifier.fillMaxSize()) {
                    QuizIllustration(question = q, isVisible = shouldShowIllustration, modifier = Modifier.fillMaxSize())
                }
            }

            Card(
                modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp).border(1.5.dp, Color(0xFFE2E8F0), RoundedCornerShape(22.dp)),
                colors = CardDefaults.cardColors(containerColor = Color.White.copy(alpha = 0.95f)),
                shape = RoundedCornerShape(22.dp)
            ) {
                Column(modifier = Modifier.fillMaxWidth().padding(14.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Box(modifier = Modifier.background(accentColor, RoundedCornerShape(8.dp)).padding(horizontal = 10.dp, vertical = 4.dp)) {
                        Text(text = "PERTANYAAN", fontSize = 10.sp, fontWeight = FontWeight.Black, color = Color.White, letterSpacing = 1.sp)
                    }
                    Spacer(modifier = Modifier.height(6.dp))
                    Text(text = q.text, fontSize = 16.sp, fontWeight = FontWeight.Black, color = Color(0xFF1F2937), textAlign = TextAlign.Center, lineHeight = 20.sp)
                }
            }

            if (isObs) {
                Button(
                    onClick = { vm.skipObservation() },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(56.dp)
                        .border(2.dp, Color(0xFFB45309), RoundedCornerShape(18.dp))
                        .testTag("skip_observation_button"),
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFBBF24)),
                    shape = RoundedCornerShape(18.dp),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 4.dp)
                ) {
                    Row(horizontalArrangement = Arrangement.Center, verticalAlignment = Alignment.CenterVertically) {
                        Text("💡", fontSize = 20.sp)
                        Spacer(modifier = Modifier.width(8.dp))
                        Text(text = "YUK, JAWAB SOAL!", fontSize = 16.sp, fontWeight = FontWeight.Black, color = Color(0xFF78350F))
                    }
                }
            } else {
                Column(modifier = Modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    val labelABC = listOf("A", "B", "C", "D")
                    val colorsList = listOf(Color(0xFFEF4444), Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFF8B5CF6))

                    q.options.forEachIndexed { index, option ->
                        OptionButtonCard(
                            letter = labelABC[index],
                            text = option,
                            isSelected = selectedIdx == index,
                            bulletColor = colorsList[index],
                            onSelect = { vm.submitAnswer(index) }
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun OptionButtonCard(
    letter: String,
    text: String,
    isSelected: Boolean,
    bulletColor: Color,
    onSelect: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(18.dp))
            .clickable(onClick = onSelect)
            .border(1.5.dp, if (isSelected) Color(0xFF3B82F6) else Color(0xFFCBD5E1), RoundedCornerShape(18.dp))
            .testTag("option_${letter}"),
        colors = CardDefaults.cardColors(containerColor = if (isSelected) Color(0xFFEFF6FF) else Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = if (isSelected) 1.dp else 0.dp)
    ) {
        Row(modifier = Modifier.fillMaxWidth().padding(horizontal = 14.dp, vertical = 10.dp), verticalAlignment = Alignment.CenterVertically) {
            Box(
                modifier = Modifier
                    .size(34.dp)
                    .clip(CircleShape)
                    .background(if (isSelected) Color(0xFF3B82F6) else bulletColor.copy(alpha = 0.12f)),
                contentAlignment = Alignment.Center
            ) {
                Text(text = letter, fontSize = 14.sp, fontWeight = FontWeight.Black, color = if (isSelected) Color.White else bulletColor)
            }
            Spacer(modifier = Modifier.width(12.dp))
            Text(text = text, fontSize = 14.sp, fontWeight = FontWeight.Bold, color = Color(0xFF334155), lineHeight = 18.sp, modifier = Modifier.weight(1f))
        }
    }
}

@Composable
fun SummaryScreen(
    levelId: Int,
    stageId: Int,
    isSuccess: Boolean,
    stars: Int,
    timeSpentMs: Long,
    vm: QuizViewModel
) {
    val q = QuizQuestions.getQuestions().firstOrNull { it.levelId == levelId && it.stageId == stageId } ?: return

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF0C1F3D))
    ) {
        DecorativeConfetti()

        Column(
            modifier = Modifier
                .fillMaxSize()
                .statusBarsPadding()
                .navigationBarsPadding()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp, vertical = 24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Top
        ) {
            Spacer(modifier = Modifier.height(16.dp))

            Surface(
                color = Color(0xFF1B365D),
                shape = RoundedCornerShape(50),
                border = BorderStroke(1.dp, Color(0xFF2E5B8E)),
                modifier = Modifier.padding(bottom = 12.dp)
            ) {
                Text(
                    text = "LEVEL $levelId",
                    fontSize = 11.sp,
                    fontWeight = FontWeight.Black,
                    color = Color(0xFF90CDF4),
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 6.dp),
                    letterSpacing = 1.sp
                )
            }

            Text(
                text = if (isSuccess) "SELESAI!" else "BELUM TEPAT!",
                fontSize = 38.sp,
                fontWeight = FontWeight.Black,
                color = Color.White,
                letterSpacing = 1.sp,
                modifier = Modifier.padding(bottom = 16.dp)
            )

            val star1Scale = remember { Animatable(0f) }
            val star2Scale = remember { Animatable(0f) }
            val star3Scale = remember { Animatable(0f) }
            val star1Rotation = remember { Animatable(-45f) }
            val star2Rotation = remember { Animatable(-45f) }
            val star3Rotation = remember { Animatable(-45f) }

            val centerStarEarned = isSuccess && stars >= 1
            val leftStarEarned = isSuccess && stars >= 2
            val rightStarEarned = isSuccess && stars >= 3

            LaunchedEffect(isSuccess, stars) {
                if (isSuccess) {
                    delay(300)
                    if (centerStarEarned) vm.soundManager.playSound(SfxType.CLICK)
                    launch { star1Rotation.animateTo(0f, animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessLow)) }
                    star1Scale.animateTo(1f, animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessLow))

                    delay(250)
                    if (leftStarEarned) vm.soundManager.playSound(SfxType.CLICK)
                    launch { star2Rotation.animateTo(0f, animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessLow)) }
                    star2Scale.animateTo(1f, animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessLow))

                    delay(250)
                    if (rightStarEarned) vm.soundManager.playSound(SfxType.CLICK)
                    launch { star3Rotation.animateTo(0f, animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessLow)) }
                    star3Scale.animateTo(1f, animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessLow))
                } else {
                    delay(200)
                    launch { star1Scale.animateTo(1f, animationSpec = tween(300)) }
                    launch { star2Scale.animateTo(1f, animationSpec = tween(300)) }
                    launch { star3Scale.animateTo(1f, animationSpec = tween(300)) }
                    launch { star1Rotation.animateTo(0f, animationSpec = tween(300)) }
                    launch { star2Rotation.animateTo(0f, animationSpec = tween(300)) }
                    launch { star3Rotation.animateTo(0f, animationSpec = tween(300)) }
                }
            }

            Row(
                horizontalArrangement = Arrangement.spacedBy(16.dp),
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.padding(bottom = 24.dp)
            ) {
                val leftColor = if (leftStarEarned) Color(0xFFFDC83A) else Color.White.copy(alpha = 0.25f)
                Icon(imageVector = Icons.Filled.Star, contentDescription = null, tint = leftColor,
                    modifier = Modifier.size(46.dp).graphicsLayer(scaleX = star2Scale.value, scaleY = star2Scale.value, rotationZ = star2Rotation.value))

                val centerColor = if (centerStarEarned) Color(0xFFFDC83A) else Color.White.copy(alpha = 0.25f)
                Icon(imageVector = Icons.Filled.Star, contentDescription = null, tint = centerColor,
                    modifier = Modifier.size(68.dp).graphicsLayer(scaleX = star1Scale.value, scaleY = star1Scale.value, rotationZ = star1Rotation.value))

                val rightColor = if (rightStarEarned) Color(0xFFFDC83A) else Color.White.copy(alpha = 0.25f)
                Icon(imageVector = Icons.Filled.Star, contentDescription = null, tint = rightColor,
                    modifier = Modifier.size(46.dp).graphicsLayer(scaleX = star3Scale.value, scaleY = star3Scale.value, rotationZ = star3Rotation.value))
            }

            val baseScore = if (isSuccess) 500 else 0
            val starBonus = if (isSuccess) when (stars) { 3 -> 500; 2 -> 300; 1 -> 150; else -> 0 } else 0
            val timeBonus = if (isSuccess) maxOf(0, (15000 - timeSpentMs) / 20).toInt().coerceAtMost(500) else 0
            val totalScore = baseScore + starBonus + timeBonus

            val animatedScore = remember { Animatable(0f) }
            LaunchedEffect(isSuccess, totalScore) {
                if (isSuccess) {
                    delay(1200)
                    animatedScore.animateTo(totalScore.toFloat(), animationSpec = tween(durationMillis = 1100, easing = LinearOutSlowInEasing))
                } else {
                    animatedScore.snapTo(0f)
                }
            }

            Card(
                modifier = Modifier.fillMaxWidth(0.88f),
                colors = CardDefaults.cardColors(containerColor = Color.White),
                shape = RoundedCornerShape(24.dp),
                elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
            ) {
                Column(modifier = Modifier.padding(horizontal = 24.dp, vertical = 24.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Text(text = "Skor Anda", fontSize = 15.sp, fontWeight = FontWeight.Bold, color = Color(0xFF5A7295))
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(text = "${animatedScore.value.toInt()}", fontSize = 62.sp, fontWeight = FontWeight.Black, color = Color(0xFF0F315E))
                    Spacer(modifier = Modifier.height(12.dp))
                    Row(modifier = Modifier.fillMaxWidth().padding(horizontal = 4.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("Skor Dasar", fontSize = 14.sp, color = Color(0xFF718096))
                        Text("$baseScore", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = Color(0xFF2D3748))
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    Row(modifier = Modifier.fillMaxWidth().padding(horizontal = 4.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("Bonus Bintang", fontSize = 14.sp, color = Color(0xFF718096))
                        Text("+$starBonus", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = Color(0xFFD97706))
                    }
                    Spacer(modifier = Modifier.height(4.dp))
                    Row(modifier = Modifier.fillMaxWidth().padding(horizontal = 4.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                        Text("Bonus Kecepatan", fontSize = 14.sp, color = Color(0xFF718096))
                        Text("+$timeBonus", fontSize = 14.sp, fontWeight = FontWeight.Bold, color = Color(0xFF0D9488))
                    }

                    Box(modifier = Modifier.fillMaxWidth().padding(vertical = 12.dp).height(1.dp).background(Color(0xFFE2E8F0)))

                    val secondsTotal = timeSpentMs / 1000
                    val sMinutes = secondsTotal / 60
                    val sSeconds = secondsTotal % 60
                    val timeFormatted = "${sMinutes.toString().padStart(2, '0')}:${sSeconds.toString().padStart(2, '0')}"
                    val accuracyFormatted = if (isSuccess) when (stars) { 3 -> "100%"; 2 -> "95%"; else -> "90%" } else "0%"

                    Row(modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                        Text(text = "Waktu", fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Color(0xFF4A5568))
                        Text(text = timeFormatted, fontSize = 15.sp, fontWeight = FontWeight.ExtraBold, color = Color(0xFF0F315E))
                    }
                    Row(modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp), horizontalArrangement = Arrangement.SpaceBetween, verticalAlignment = Alignment.CenterVertically) {
                        Text(text = "Akurasi", fontSize = 15.sp, fontWeight = FontWeight.Medium, color = Color(0xFF4A5568))
                        Text(text = accuracyFormatted, fontSize = 15.sp, fontWeight = FontWeight.ExtraBold, color = Color(0xFF0F315E))
                    }
                }
            }

            Row(modifier = Modifier.fillMaxWidth(0.88f).padding(top = 22.dp), horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                if (isSuccess) {
                    val nextStg = stageId + 1
                    val onLanjutClick = if (nextStg <= 10) {
                        { vm.navigateTo(Screen.Gameplay(levelId, nextStg)) }
                    } else if (levelId < 3) {
                        { vm.navigateTo(Screen.StageSelect(levelId + 1)) }
                    } else {
                        { vm.navigateTo(Screen.Splash) }
                    }

                    Button(
                        onClick = { vm.navigateTo(Screen.Gameplay(levelId, stageId)) },
                        modifier = Modifier.weight(1f).height(54.dp).testTag("retry_stage_button"),
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2D81CD)),
                        shape = RoundedCornerShape(14.dp),
                        elevation = ButtonDefaults.buttonElevation(defaultElevation = 2.dp)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.Center) {
                            Icon(imageVector = Icons.Filled.Refresh, contentDescription = null, tint = Color.White, modifier = Modifier.size(18.dp))
                            Spacer(modifier = Modifier.width(6.dp))
                            Text(text = "ULANGI", fontSize = 14.sp, fontWeight = FontWeight.Black, color = Color.White)
                        }
                    }

                    Button(
                        onClick = onLanjutClick,
                        modifier = Modifier.weight(1f).height(54.dp).testTag("next_stage_button"),
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFFDC83A)),
                        shape = RoundedCornerShape(14.dp),
                        elevation = ButtonDefaults.buttonElevation(defaultElevation = 2.dp)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.Center) {
                            Text(text = "LANJUT", fontSize = 14.sp, fontWeight = FontWeight.Black, color = Color(0xFF0F2547))
                            Spacer(modifier = Modifier.width(6.dp))
                            Icon(imageVector = Icons.Filled.ArrowForward, contentDescription = null, tint = Color(0xFF0F2547), modifier = Modifier.size(18.dp))
                        }
                    }
                } else {
                    Button(
                        onClick = { vm.navigateTo(Screen.Gameplay(levelId, stageId)) },
                        modifier = Modifier.fillMaxWidth().height(54.dp).testTag("retry_stage_button"),
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2D81CD)),
                        shape = RoundedCornerShape(14.dp),
                        elevation = ButtonDefaults.buttonElevation(defaultElevation = 2.dp)
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.Center) {
                            Icon(imageVector = Icons.Filled.Refresh, contentDescription = null, tint = Color.White, modifier = Modifier.size(18.dp))
                            Spacer(modifier = Modifier.width(6.dp))
                            Text(text = "COBA LAGI", fontSize = 14.sp, fontWeight = FontWeight.Black, color = Color.White)
                        }
                    }
                }
            }

            Card(
                modifier = Modifier.padding(top = 16.dp).size(54.dp).clickable { vm.navigateTo(Screen.StageSelect(levelId)) }.testTag("back_to_stages_button"),
                shape = RoundedCornerShape(14.dp),
                colors = CardDefaults.cardColors(containerColor = Color(0xFF1A3961)),
                border = BorderStroke(1.dp, Color(0xFF2C5585))
            ) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Icon(imageVector = Icons.Filled.Home, contentDescription = "Menu Utama", tint = Color.White, modifier = Modifier.size(24.dp))
                }
            }

            Surface(
                color = Color(0xFF1B365D).copy(alpha = 0.5f),
                shape = RoundedCornerShape(16.dp),
                border = BorderStroke(1.dp, Color(0xFF2A4D80).copy(alpha = 0.4f)),
                modifier = Modifier.fillMaxWidth(0.88f).padding(top = 20.dp)
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Text(text = "💡 PENJELASAN:", fontSize = 11.sp, fontWeight = FontWeight.Black, color = Color(0xFF90CDF4))
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(text = q.explanation, fontSize = 12.sp, color = Color.White.copy(alpha = 0.9f), lineHeight = 17.sp)
                }
            }
        }

        if (isSuccess) {
            ConfettiView(modifier = Modifier.fillMaxSize())
        }
    }
}

@Composable
fun DecorativeConfetti() {
    Box(modifier = Modifier.fillMaxSize()) {
        Canvas(modifier = Modifier.size(width = 24.dp, height = 12.dp).align(Alignment.CenterStart).offset(x = 24.dp, y = 100.dp)) {
            drawContext.canvas.save(); drawContext.canvas.rotate(35f); drawRect(color = Color(0xFF4ADE80)); drawContext.canvas.restore()
        }
        Canvas(modifier = Modifier.size(width = 18.dp, height = 10.dp).align(Alignment.CenterEnd).offset(x = (-24).dp, y = 140.dp)) {
            drawContext.canvas.save(); drawContext.canvas.rotate(-20f); drawRect(color = Color(0xFFF87171)); drawContext.canvas.restore()
        }
        Canvas(modifier = Modifier.size(width = 14.dp, height = 14.dp).align(Alignment.TopEnd).offset(x = (-30).dp, y = 180.dp)) {
            drawContext.canvas.save(); drawContext.canvas.rotate(15f); drawRect(color = Color(0xFFFB923C)); drawContext.canvas.restore()
        }
        Canvas(modifier = Modifier.size(width = 16.dp, height = 16.dp).align(Alignment.CenterEnd).offset(x = (-10).dp, y = (-50).dp)) {
            drawContext.canvas.save(); drawContext.canvas.rotate(45f); drawRect(color = Color(0xFFF472B6)); drawContext.canvas.restore()
        }
        Canvas(modifier = Modifier.size(width = 12.dp, height = 12.dp).align(Alignment.TopStart).offset(x = 40.dp, y = 120.dp)) {
            drawContext.canvas.save(); drawContext.canvas.rotate(-30f); drawRect(color = Color(0xFF60A5FA)); drawContext.canvas.restore()
        }
    }
}

private data class ConfettiParticle(
    var x: Float, var y: Float,
    var vx: Float, var vy: Float,
    var rot: Float, var rotV: Float,
    val color: Color, val size: Float
)

@Composable
fun ConfettiView(modifier: Modifier = Modifier) {
    val colors = listOf(Color(0xFFEF4444), Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFFFFC107), Color(0xFF8B5CF6))

    val particles = remember {
        List(120) {
            ConfettiParticle(
                x = 0f, y = 0f, vx = 0f, vy = 0f,
                rot = (Random.nextDouble() * 360).toFloat(),
                rotV = (Random.nextDouble() * 10 - 5).toFloat(),
                color = colors[Random.nextInt(colors.size)],
                size = (Random.nextDouble() * 15f + 15f).toFloat()
            )
        }
    }

    val animationProgress = remember { Animatable(0f) }
    LaunchedEffect(Unit) {
        animationProgress.animateTo(targetValue = 1f, animationSpec = tween(durationMillis = 4000, easing = LinearOutSlowInEasing))
    }

    Canvas(modifier = modifier) {
        val progress = animationProgress.value
        if (progress >= 1f) return@Canvas

        val cx = size.width / 2f
        val cy = size.height * 0.2f

        if (particles.first().x == 0f) {
            for (p in particles) {
                p.x = cx + ((Random.nextFloat() - 0.5f) * size.width * 0.05f)
                p.y = cy + ((Random.nextFloat() - 0.5f) * size.height * 0.05f)
                p.vx = (Random.nextFloat() - 0.5f) * size.width * 0.06f
                p.vy = -(Random.nextFloat() * size.height * 0.035f + size.height * 0.01f)
            }
        }

        val gravity = size.height * 0.0008f
        val drag = 0.98f

        for (p in particles) {
            p.x += p.vx; p.y += p.vy; p.vy += gravity; p.vx *= drag; p.vy *= drag; p.rot += p.rotV
        }

        val globalAlpha = if (progress > 0.8f) ((1f - progress) * 5f) else 1f

        for (p in particles) {
            val pivot = Offset(p.x + p.size / 2, p.y + p.size / 2)
            drawContext.canvas.save()
            drawContext.canvas.translate(pivot.x, pivot.y)
            drawContext.canvas.rotate(p.rot)
            drawContext.canvas.translate(-pivot.x, -pivot.y)
            drawRect(
                color = p.color.copy(alpha = globalAlpha.coerceIn(0f, 1f)),
                topLeft = Offset(p.x, p.y),
                size = androidx.compose.ui.geometry.Size(p.size, p.size * 1.5f)
            )
            drawContext.canvas.restore()
        }
    }
}
