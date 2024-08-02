package dev.pyrossh.onlyBible.composables

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.ListItem
import androidx.compose.material3.ListItemDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import dev.pyrossh.onlyBible.domain.Bible
import dev.pyrossh.onlyBible.domain.bibles
import java.util.Locale

@Composable
fun BibleSelector(
    bible: Bible,
    onSelected: (Bible) -> Unit,
    onClose: () -> Unit,
) {
    val context = LocalContext.current
    val height = context.resources.configuration.screenHeightDp.dp / 2
    val bibleList = bibles.sortedBy { it != bible }
    Dialog(onDismissRequest = { onClose() }) {
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .height(height),
            shape = RoundedCornerShape(8.dp),
        ) {
            LazyColumn {
                items(bibleList) {
                    val loc = Locale(it.languageCode)
                    ListItem(
                        modifier = Modifier.clickable {
                            onSelected(it)
                        },
                        colors = ListItemDefaults.colors(
                            containerColor = if (it == bible)
                                MaterialTheme.colorScheme.primaryContainer
                            else
                                MaterialTheme.colorScheme.background
                        ),
                        headlineContent = {
                            Text(
                                modifier = Modifier.padding(start = 4.dp),
                                fontWeight = FontWeight.W600,
                                text = loc.getDisplayName(Locale.ENGLISH),
                            )
                        },
                        supportingContent = {
                            Text(
                                modifier = Modifier.padding(start = 4.dp),
                                text = if (it.version != null)
                                    it.version.uppercase()
                                else
                                    loc.getDisplayName(loc)
                            )
                        }
                    )
                }
            }
        }
    }
}