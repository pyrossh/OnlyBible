package composables

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
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.intl.Locale
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import domain.Bible
import domain.bibles

@Composable
fun BibleSelector(
    bible: Bible,
    onSelected: (Bible) -> Unit,
    onClose: () -> Unit,
) {
//    val context = LocalContext.current
    val height = 400.dp // context.resources.configuration.screenHeightDp.dp / 2
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
            ListItem(
                colors = ListItemDefaults.colors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                ),
                headlineContent = {
                    Text(
                        modifier = Modifier.padding(start = 4.dp),
                        fontWeight = FontWeight.W600,
                        text = "Bibles",
                    )
                },
            )
            LazyColumn(
                state = scrollState
            ) {
                items(bibles) {
                    val loc = Locale(it.languageCode)
                    ListItem(
                        modifier = Modifier.clickable {
                            onSelected(it)
                        },
                        headlineContent = {
                            Text(
                                modifier = Modifier.padding(start = 4.dp),
                                fontWeight = FontWeight.W600,
                                text = loc.language,
                            )
                        },
                        supportingContent = {
                            Text(
                                modifier = Modifier.padding(start = 4.dp),
                                text = if (it.version != null)
                                    it.version.uppercase()
                                else
                                    loc.language
                            )
                        }
                    )
                }
            }
        }
    }
}