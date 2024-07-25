package dev.pyrossh.onlyBible.composables

import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
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
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
@OptIn(ExperimentalMaterial3Api::class)
fun EmbeddedSearchBar(
    query: String,
    onQueryChange: (String) -> Unit,
    onSearch: ((String) -> Unit),
    onClose: () -> Unit,
    content: @Composable () -> Unit
) {
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
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp)
                .focusRequester(textFieldFocusRequester),
            query = query,
            onQueryChange = onQueryChange,
            onSearch = onSearch,
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
                        onClose()
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
            content()
        }
    }
}