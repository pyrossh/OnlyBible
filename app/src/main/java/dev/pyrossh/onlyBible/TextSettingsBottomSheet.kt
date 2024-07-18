package dev.pyrossh.onlyBible

import android.app.UiModeManager
import android.content.Context.UI_MODE_SERVICE
import android.content.res.Configuration
import android.content.res.Configuration.UI_MODE_NIGHT_NO
import android.content.res.Configuration.UI_MODE_NIGHT_UNDEFINED
import android.content.res.Configuration.UI_MODE_NIGHT_YES
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
import androidx.compose.material.icons.filled.DarkMode
import androidx.compose.material.icons.filled.FormatBold
import androidx.compose.material.icons.filled.FormatLineSpacing
import androidx.compose.material.icons.filled.FormatSize
import androidx.compose.material.icons.filled.LightMode
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.launch

@Composable
@OptIn(ExperimentalMaterial3Api::class)
fun TextSettingsBottomSheet(model: AppViewModel) {
    val uiModeManager = LocalContext.current.getSystemService(UI_MODE_SERVICE) as UiModeManager
    val uiMode = model.uiMode and Configuration.UI_MODE_NIGHT_MASK
    val scope = rememberCoroutineScope()
    val sheetState = rememberModalBottomSheetState()
    val fontType = FontType.valueOf(model.fontType)
    return ModalBottomSheet(
        tonalElevation = 2.dp,
        sheetState = sheetState,
        onDismissRequest = {
            scope.launch {
                sheetState.hide()
            }.invokeOnCompletion {
                model.closeSheet()
            }
        },
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
                    text = "Text Settings",
                    style = TextStyle(
                        fontSize = 18.sp,
                        fontWeight = FontWeight.W600,
                        color = MaterialTheme.colorScheme.onBackground,
                    )
                )
                Row(horizontalArrangement = Arrangement.End) {
                    IconButton(onClick = {
                        scope.launch {
                            sheetState.hide()
                        }.invokeOnCompletion {
                            model.closeSheet()
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
                        model.fontSizeDelta -= 1
                    }) {
                    Column(
                        modifier = Modifier.background(MaterialTheme.colorScheme.background),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Filled.FormatSize,
                            contentDescription = "Decrease Font Size",
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
                        model.fontSizeDelta += 1
                    }) {
                    Column(
                        modifier = Modifier.background(MaterialTheme.colorScheme.background),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Filled.FormatSize,
                            contentDescription = "Increase Font size"
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
                        model.fontBoldEnabled = !model.fontBoldEnabled
                    }) {
                    Column(
                        modifier = Modifier.background(MaterialTheme.colorScheme.background),
                        verticalArrangement = Arrangement.Center,
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Icon(
                            imageVector = Icons.Filled.FormatBold,
                            contentDescription = "Bold",
//                            tint = if (settings.boldEnabled) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onBackground,
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
                        modifier = Modifier.background(MaterialTheme.colorScheme.background),
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
                    Surface(
                        shape = RoundedCornerShape(8.dp),
                        border = if (fontType == it) BorderStroke(
                            2.dp, MaterialTheme.colorScheme.primary
                        ) else null,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(60.dp)
                            .padding(end = 16.dp)
                            .weight(1f),
                        onClick = {
                            model.fontType = it.name
                        }) {
                        Column(
                            modifier = Modifier.background(
                                MaterialTheme.colorScheme.background
                            ),
                            verticalArrangement = Arrangement.Center,
                            horizontalAlignment = Alignment.CenterHorizontally
                        ) {
                            Text(
                                text = it.name,
                                style = TextStyle(
                                    fontFamily = it.family(),
                                    fontSize = 18.sp,
                                    fontWeight = FontWeight.W600,
                                    color = if (fontType == it)
                                        MaterialTheme.colorScheme.primary
                                    else
                                        MaterialTheme.colorScheme.onSurface,
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
                listOf(UI_MODE_NIGHT_NO, UI_MODE_NIGHT_YES, UI_MODE_NIGHT_UNDEFINED).map {
                    Surface(
                        shape = RoundedCornerShape(8.dp),
                        border = if (uiMode == it) BorderStroke(
                            2.dp, MaterialTheme.colorScheme.primary
                        ) else null,
                        color = if (uiMode == it)
                            MaterialTheme.colorScheme.primary
                        else
                            MaterialTheme.colorScheme.onSurface,
                        contentColor = if (uiMode == it)
                            MaterialTheme.colorScheme.primary
                        else
                            MaterialTheme.colorScheme.onSurface,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(60.dp)
                            .padding(end = 16.dp)
                            .weight(1f),
                        onClick = {
                            scope.launch {
                                sheetState.hide()
                                model.closeSheet()
                                when (it) {
                                    UI_MODE_NIGHT_NO -> uiModeManager.setApplicationNightMode(
                                        UiModeManager.MODE_NIGHT_NO
                                    )

                                    UI_MODE_NIGHT_YES -> uiModeManager.setApplicationNightMode(
                                        UiModeManager.MODE_NIGHT_YES
                                    )

                                    UI_MODE_NIGHT_UNDEFINED -> uiModeManager.setApplicationNightMode(
                                        UiModeManager.MODE_NIGHT_AUTO
                                    )
                                }
                            }
                        }
                    ) {
                        when (it) {
                            UI_MODE_NIGHT_NO -> Icon(
                                imageVector = Icons.Filled.LightMode,
                                contentDescription = "Light",
                                modifier = Modifier
                                    .background(MaterialTheme.colorScheme.background)
                                    .padding(12.dp)
                            )

                            UI_MODE_NIGHT_YES -> Icon(
                                imageVector = Icons.Filled.DarkMode,
                                contentDescription = "Dark",
                                modifier = Modifier
                                    .background(MaterialTheme.colorScheme.background)
                                    .padding(12.dp)
                            )

                            UI_MODE_NIGHT_UNDEFINED -> Column(
                                modifier = Modifier.background(
                                    color = MaterialTheme.colorScheme.background,
                                ),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Text(
                                    text = "Auto",
                                    style = TextStyle(
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.Medium,
                                    ),
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}