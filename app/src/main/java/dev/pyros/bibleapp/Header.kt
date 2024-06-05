package dev.pyros.bibleapp

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun Header(
    chapterIndex: Int,
) {
    Row(modifier = Modifier.padding(bottom = 8.dp)) {
        Text(
            modifier = Modifier.combinedClickable(
                enabled = true,
                onClick = {
                },
                onDoubleClick = {
                }
            ),
            style = TextStyle(
                fontSize = 22.sp,
                fontWeight = FontWeight.W600,
            ),
            text = "Genesis ${chapterIndex + 1}"
        )
    }
}