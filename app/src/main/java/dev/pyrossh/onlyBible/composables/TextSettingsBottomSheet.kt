package dev.pyrossh.onlyBible.composables

import android.app.UiModeManager.MODE_NIGHT_AUTO
import android.app.UiModeManager.MODE_NIGHT_NO
import android.app.UiModeManager.MODE_NIGHT_YES
import android.view.SoundEffectConstants
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
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import dev.pyrossh.onlyBible.AppViewModel
import dev.pyrossh.onlyBible.FontType
import kotlinx.coroutines.launch

@Composable
@OptIn(ExperimentalMaterial3Api::class)
fun TextSettingsBottomSheet(
    model: AppViewModel,
    onDismiss: () -> Unit,
) {
    val view = LocalView.current
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    return ModalBottomSheet(
        tonalElevation = 2.dp,
        onDismissRequest = {
            onDismiss()
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
                    text = model.bible.tSettings,
                    style = TextStyle(
                        fontSize = 18.sp,
                        fontWeight = FontWeight.W600,
                        color = MaterialTheme.colorScheme.onBackground,
                    )
                )
                Row(horizontalArrangement = Arrangement.End) {
                    IconButton(onClick = {
                        view.playSoundEffect(SoundEffectConstants.CLICK)
                        onDismiss()
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
                        view.playSoundEffect(SoundEffectConstants.CLICK)
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
                        view.playSoundEffect(SoundEffectConstants.CLICK)
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
                        view.playSoundEffect(SoundEffectConstants.CLICK)
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
                    onClick = {
                        view.playSoundEffect(SoundEffectConstants.CLICK)
                        if (model.lineSpacingDelta > 5) {
                            model.lineSpacingDelta = 0
                        } else {
                            model.lineSpacingDelta += 1
                        }
                    }) {
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
                        border = if (model.fontType == it) BorderStroke(
                            2.dp, MaterialTheme.colorScheme.primary
                        ) else null,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(60.dp)
                            .padding(end = 16.dp)
                            .weight(1f),
                        onClick = {
                            view.playSoundEffect(SoundEffectConstants.CLICK)
                            model.fontType = it
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
                                    color = if (model.fontType == it)
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
                listOf(MODE_NIGHT_NO, MODE_NIGHT_YES, MODE_NIGHT_AUTO).map {
                    Surface(
                        shape = RoundedCornerShape(8.dp),
                        border = if (model.nightMode == it) BorderStroke(
                            2.dp, MaterialTheme.colorScheme.primary
                        ) else null,
                        color = if (model.nightMode == it)
                            MaterialTheme.colorScheme.primary
                        else
                            MaterialTheme.colorScheme.onSurface,
                        contentColor = if (model.nightMode == it)
                            MaterialTheme.colorScheme.primary
                        else
                            MaterialTheme.colorScheme.onSurface,
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(60.dp)
                            .padding(end = 16.dp)
                            .weight(1f),
                        onClick = {
                            view.playSoundEffect(SoundEffectConstants.CLICK)
                            scope.launch {
                                onDismiss()
                                model.setApplicationNightMode(context, it)
                            }
                        }
                    ) {
                        when (it) {
                            MODE_NIGHT_NO -> Icon(
                                imageVector = Icons.Filled.LightMode,
                                contentDescription = "Light",
                                modifier = Modifier
                                    .background(MaterialTheme.colorScheme.background)
                                    .padding(12.dp)
                            )

                            MODE_NIGHT_YES -> Icon(
                                imageVector = Icons.Filled.DarkMode,
                                contentDescription = "Dark",
                                modifier = Modifier
                                    .background(MaterialTheme.colorScheme.background)
                                    .padding(12.dp)
                            )

                            MODE_NIGHT_AUTO -> Column(
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