package dev.pyrossh.onlyBible.composables

import android.view.SoundEffectConstants
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Close
import androidx.compose.material.icons.rounded.Search
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ProvideTextStyle
import androidx.compose.material3.SearchBar
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import dev.pyrossh.onlyBible.AppViewModel

@Composable
@OptIn(ExperimentalMaterial3Api::class)
fun EmbeddedSearchBar(
    modifier: Modifier = Modifier,
    model: AppViewModel,
    onDismiss: () -> Unit,
) {
    val view = LocalView.current
    val searchText by model.searchText.collectAsState()
    val searchedVerses by model.searchedVerses.collectAsState()
    val textFieldFocusRequester = remember { FocusRequester() }
    SideEffect {
        textFieldFocusRequester.requestFocus()
    }
    ProvideTextStyle(
        value = TextStyle(
            fontSize = 18.sp,
            color = MaterialTheme.colorScheme.onSurface,
        )
    ) {
        SearchBar(
            modifier = modifier
                .fillMaxSize()
                .navigationBarsPadding()
                .focusRequester(textFieldFocusRequester),
            query = searchText,
            onQueryChange = model::onSearchTextChange,
            onSearch = model::onSearchTextChange,
            active = true,
            onActiveChange = {},
            placeholder = {
                Text(
                    style = TextStyle(
                        fontSize = 18.sp,
                    ),
                    text = "Search"
                )
            },
            leadingIcon = {
                Icon(
                    imageVector = Icons.Rounded.Search,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onSurface,
                )
            },
            trailingIcon = {
                IconButton(
                    onClick = {
                        view.playSoundEffect(SoundEffectConstants.CLICK)
                        onDismiss()
                    },
                ) {
                    Icon(
                        imageVector = Icons.Rounded.Close,
                        contentDescription = "Close",
                        tint = MaterialTheme.colorScheme.onSurface,
                    )
                }
            },
            tonalElevation = 0.dp,
        ) {
            val groups = searchedVerses.groupBy { "${it.bookName} ${it.chapterIndex + 1}" }
            LazyColumn {
                groups.forEach {
                    item(
                        contentType = "header"
                    ) {
                        Text(
                            modifier = Modifier.padding(
                                vertical = 12.dp,
                            ),
                            style = TextStyle(
                                fontFamily = model.fontType.family(),
                                fontSize = (16 + model.fontSizeDelta).sp,
                                fontWeight = FontWeight.W700,
                                color = MaterialTheme.colorScheme.onSurface,
                            ),
                            text = it.key,
                        )
                    }
                    items(it.value) { v ->
                        VerseText(
                            model = model,
                            fontType = model.fontType,
                            fontSizeDelta = model.fontSizeDelta,
                            fontBoldEnabled = model.fontBoldEnabled,
                            verse = v,
                            highlightWord = searchText,
                        )
                        Spacer(modifier = Modifier.padding(bottom = 8.dp))
                    }
                }
            }
        }
    }
}