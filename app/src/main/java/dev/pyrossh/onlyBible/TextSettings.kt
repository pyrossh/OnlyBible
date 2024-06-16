package dev.pyrossh.onlyBible

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.FormatBold
import androidx.compose.material.icons.filled.FormatLineSpacing
import androidx.compose.material.icons.filled.FormatSize
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.launch

@Composable
@OptIn(ExperimentalMaterial3Api::class)
fun TextSettingsBottomSheet() {
    val scope = rememberCoroutineScope()
    val sheetState = rememberModalBottomSheetState()
    val state = LocalState.current!!
    return ModalBottomSheet(
        onDismissRequest = {
            scope.launch {
                state.closeSheet()
            }
        }, sheetState = sheetState
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 16.dp),
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Text(
                    text = "Text Settings", fontSize = 20.sp, fontWeight = FontWeight.W500
                )
                Row(horizontalArrangement = Arrangement.End) {
                    IconButton(onClick = {
                        scope.launch {
                            state.closeSheet()
                        }
                    }) {
                        Icon(Icons.Filled.Close, "Close")
                    }
                }
            }
            HorizontalDivider()
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Surface(shape = RoundedCornerShape(8.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(60.dp)
                        .padding(end = 16.dp)
                        .weight(1f),
                    onClick = {
                        state.updateFontSize(state.fontSizeDelta - 1)
                    }) {
                    Column(
                        modifier = Modifier.background(Color(0xFFFAFAFA)),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Filled.FormatSize,
                            contentDescription = "Bold",
                            modifier = Modifier.size(14.dp),
                        )
                    }
                }
                Surface(shape = RoundedCornerShape(8.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(60.dp)
                        .padding(end = 16.dp)
                        .weight(1f),
                    onClick = {
                        state.updateFontSize(state.fontSizeDelta + 1)
                    }) {
                    Column(
                        modifier = Modifier.background(Color(0xFFFAFAFA)),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Filled.FormatSize,
                            contentDescription = "Bold"
                        )
                    }
                }
                Surface(shape = RoundedCornerShape(8.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(60.dp)
                        .padding(end = 16.dp)
                        .weight(1f),
                    onClick = {
                        state.updateBoldEnabled(!state.boldEnabled)
                    }) {
                    Column(
                        modifier = Modifier.background(Color(0xFFFAFAFA)),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Filled.FormatBold,
                            contentDescription = "Bold"
                        )
                    }
                }
                Surface(shape = RoundedCornerShape(8.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(60.dp)
                        .padding(end = 16.dp)
                        .weight(1f),
                    onClick = {}) {
                    Column(
                        modifier = Modifier.background(Color(0xFFFAFAFA)),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Filled.FormatLineSpacing,
                            contentDescription = "Line Spacing"
                        )
                    }
                }
            }
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically,
            ) {
                FontType.entries.map {
                    Surface(shape = RoundedCornerShape(8.dp),
                        border = if (state.fontType == it) BorderStroke(
                            2.dp, Color(0xFF72abbf)
                        ) else null,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(60.dp)
                            .padding(end = 16.dp)
                            .weight(1f),
                        onClick = {
                            state.updateFontType(it)
                        }) {
                        Column(
                            modifier = Modifier.background(Color(0xFFFAFAFA)),
                            verticalArrangement = Arrangement.Center,
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            Text(
                                text = it.name, style = TextStyle(
                                    fontFamily = it.family(),
                                    fontSize = 18.sp,
                                    fontWeight = FontWeight.Medium,
                                )
                            )
                        }
                    }
                }
            }
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 16.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically,
            ) {
                // #72abbf on active
                // #ebe0c7 on yellow
                // #424547 on dark
                Surface(shape = RoundedCornerShape(8.dp),
                    border = BorderStroke(
                        2.dp, Color(0xFF72abbf)
                    ),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(80.dp)
                        .padding(end = 16.dp)
                        .weight(1f),
                    onClick = {}) {
                    Icon(
                        painter = painterResource(id = R.drawable.text_theme),
                        contentDescription = "Light",
                        tint = Color(0xFF424547),
                        modifier = Modifier
                            .background(Color.White)
                            .padding(8.dp)
                    )
                }
                Surface(shape = RoundedCornerShape(8.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(80.dp)
                        .padding(end = 16.dp)
                        .weight(1f),
                    onClick = {}) {
                    Icon(
                        painter = painterResource(id = R.drawable.text_theme),
                        contentDescription = "Warm",
                        tint = Color(0xFF424547),
                        modifier = Modifier
                            .background(Color(0xFFe5e0d1))
                            .padding(8.dp)
                    )
                }
                Surface(shape = RoundedCornerShape(8.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(80.dp)
                        .padding(end = 16.dp)
                        .weight(1f),
                    onClick = {}) {
                    Icon(
                        painter = painterResource(id = R.drawable.text_theme),
                        contentDescription = "Dark",
                        tint = Color(0xFFd3d7da),
                        modifier = Modifier
                            .background(Color(0xFF2c2e30))
                            .padding(8.dp)
                    )
                }
                Surface(shape = RoundedCornerShape(8.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(80.dp)
                        .padding(end = 16.dp)
                        .weight(1f),
                    onClick = {}) {
                    Column(
                        modifier = Modifier.background(Color(0xFFFAFAFA)),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = "Auto", style = TextStyle(
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Medium,
                            )
                        )
                    }
                }
            }
        }
    }
}