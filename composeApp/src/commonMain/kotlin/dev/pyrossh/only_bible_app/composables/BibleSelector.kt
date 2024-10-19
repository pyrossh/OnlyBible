package dev.pyrossh.only_bible_app.composables

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.ListItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import dev.pyrossh.only_bible_app.domain.Bible
import dev.pyrossh.only_bible_app.domain.bibles
import dev.pyrossh.only_bible_app.getScreenHeight

@Composable
fun BibleSelector(
    bible: Bible,
    onSelected: (Bible) -> Unit,
    onClose: () -> Unit,
) {
    val height = getScreenHeight()  / 2
    val bibleIndex = bibles.indexOf(bible)
    val scrollState = rememberLazyListState(
        initialFirstVisibleItemIndex = if (bibleIndex - 2 >= 0)
            bibleIndex - 2
        else
            0,
    )
    Dialog(onDismissRequest = { onClose() }) {
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .height(height),
            shape = RoundedCornerShape(8.dp),
        ) {
            LazyColumn(
                state = scrollState
            ) {
                items(bibles) {
                    ListItem(
                        modifier = Modifier.clickable {
                            onSelected(it)
                        },
                        headlineContent = {
                            Text(
                                modifier = Modifier.padding(start = 4.dp),
                                fontWeight = FontWeight.W600,
                                text = it.languageEnglish
                            )
                        },
                        supportingContent = {
                            Text(
                                modifier = Modifier.padding(start = 4.dp),
                                text = it.languageNative
                            )
                        }
                    )
                }
            }
        }
    }
}