package dev.pyrossh.onlyBible.composables

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.ButtonColors
import androidx.compose.material3.Card
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import dev.pyrossh.onlyBible.AppViewModel
import dev.pyrossh.onlyBible.ChapterScreenProps
import dev.pyrossh.onlyBible.domain.chapterSizes
import dev.pyrossh.onlyBible.domain.engTitles

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChapterSelector(
    model: AppViewModel,
    onClose: () -> Unit,
    navigateToChapter: (ChapterScreenProps) -> Unit
) {
    val context = LocalContext.current
    val height = context.resources.configuration.screenHeightDp.dp / 2
    val bookNames by model.bookNames.collectAsState()
    var expanded by remember { mutableStateOf(false) }
    var bookIndex by remember { mutableIntStateOf(model.bookIndex) }
    val scrollState = rememberLazyListState()
    val bookList = bookNames - bookNames[bookIndex]
    LaunchedEffect(key1 = bookIndex) {
        scrollState.scrollToItem(0, 0)
    }
    Dialog(onDismissRequest = { onClose() }) {
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .height(height),
            shape = RoundedCornerShape(8.dp),
        ) {
            ListItem(
                modifier = Modifier
                    .clickable {
                        expanded = !expanded
                    },
                colors = ListItemDefaults.colors(
                    containerColor = if (expanded)
                        MaterialTheme.colorScheme.primaryContainer
                    else
                        MaterialTheme.colorScheme.background
                ),
                headlineContent = {
                    Text(
                        modifier = Modifier.padding(start = 4.dp),
                        fontWeight = FontWeight.W600,
                        text = bookNames[bookIndex]
                    )
                },
                trailingContent = {
                    ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded)
                }
            )
            if (expanded) {
                LazyColumn(
                    state = scrollState,
                ) {
                    items(bookList) {
                        ListItem(
                            modifier = Modifier.clickable {
                                bookIndex = bookNames.indexOf(it)
                                expanded = false
                            },
                            headlineContent = {
                                Text(
                                    modifier = Modifier.padding(start = 4.dp),
                                    fontWeight = FontWeight.W600,
                                    text = it,
                                )
                            },
                            supportingContent = {
                                if (model.bible.languageCode != "en") {
                                    Text(
                                        modifier = Modifier.padding(start = 4.dp),
                                        text = engTitles[bookNames.indexOf(it)],
                                    )
                                }
                            }
                        )
                    }
                }
            }
            LazyVerticalGrid(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(10.dp),
                horizontalArrangement = Arrangement.spacedBy(10.dp),
                columns = GridCells.Fixed(5)
            ) {
                items(chapterSizes[bookIndex]) { c ->
                    Surface(
                        shadowElevation = 1.dp,
                        shape = RoundedCornerShape(8.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                    ) {
                        TextButton(
                            colors = ButtonColors(
                                containerColor = Color.White,
                                contentColor = Color.Black,
                                disabledContentColor = Color.Gray,
                                disabledContainerColor = Color.Gray,
                            ),
                            shape = RoundedCornerShape(8.dp),
                            onClick = {
                                onClose()
                                navigateToChapter(
                                    ChapterScreenProps(
                                        bookIndex = bookIndex,
                                        chapterIndex = c,
                                    )
                                )
                            }
                        ) {
                            Text(
                                fontWeight = FontWeight.W600,
                                text = "${c + 1}"
                            )
                        }
                    }
                }
                item {
                    Spacer(modifier = Modifier.padding(bottom = 8.dp))
                }
            }
        }
    }
}