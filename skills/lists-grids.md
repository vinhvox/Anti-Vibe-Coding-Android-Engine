# Lists & Grids

Comprehensive guide for building high-performance, jank-free, and lifecycle-safe lazy layouts in Jetpack Compose within MVI architecture.

---

## 1. Lazy Layout Fundamentals (`LazyColumn` & `LazyRow`)

Lazy layouts only compose and layout items currently visible in the viewport.

```kotlin
LazyColumn(
    modifier = Modifier.fillMaxSize(),
    state = listState
) {
    item { HeaderSection() }
    items(
        items = servers,
        key = { it.id },
        contentType = { it.itemType }
    ) { server ->
        ServerRow(server = server, onSelect = onSelectServer)
    }
    item { FooterSection() }
}
```

---

## 2. Mandatory Stable & Unique Keys

### Why Keys Matter:
1. **Item Recycling:** Enables Compose to reuse existing composables instead of destroying and re-instantiating them.
2. **Scroll State Preservation:** Retains user scroll position when items are inserted, deleted, or filtered.
3. **Animations:** Required for `Modifier.animateItemPlacement()` to smoothly animate item reordering.

```kotlin
// ❌ BAD: No key provided -> Full list recomposition on insert/delete
LazyColumn {
    items(servers) { server -> ServerRow(server) }
}

// ❌ BAD: Index-based key -> Corrupts animations and internal state on reordering
LazyColumn {
    items(servers, key = { index }) { server -> ServerRow(server) }
}

// ✅ GOOD: Unique, stable domain identifier (UUID, Long ID, distinct String)
LazyColumn {
    items(
        items = servers,
        key = { it.id }
    ) { server ->
        ServerRow(server = server)
    }
}
```

---

## 3. `contentType` for Heterogeneous Item Recycling

When rendering multiple distinct layout types in a single `LazyColumn` (e.g., Headers, Server Cards, Ads, Section Dividers), use `contentType`.

```kotlin
sealed interface FeedItem {
    val id: String
    data class Header(override val id: String, val title: String) : FeedItem
    data class ServerCard(override val id: String, val server: VpnServer) : FeedItem
    data class BannerAd(override val id: String, val adUnitId: String) : FeedItem
}

LazyColumn {
    items(
        items = feedItems,
        key = { it.id },
        contentType = { item ->
            when (item) {
                is FeedItem.Header -> "HEADER"
                is FeedItem.ServerCard -> "SERVER_CARD"
                is FeedItem.BannerAd -> "BANNER_AD"
            }
        }
    ) { item ->
        when (item) {
            is FeedItem.Header -> SectionHeader(item.title)
            is FeedItem.ServerCard -> ServerRow(item.server)
            is FeedItem.BannerAd -> AdBanner(item.adUnitId)
        }
    }
}
```

---

## 4. Preventing Nested Infinite Scrolling Crashes

### The Infinite Height Crash:
Placing a `LazyColumn` inside a container with `Modifier.verticalScroll(rememberScrollState())` crashes at runtime with:
`IllegalStateException: Vertically scrollable component was measured with an infinity maximum height constraints`.

```kotlin
// ❌ BAD: Crash at runtime!
Column(modifier = Modifier.verticalScroll(rememberScrollState())) {
    HeaderView()
    LazyColumn { // CRASH: Infinite height conflict
        items(servers, key = { it.id }) { ... }
    }
}

// ✅ GOOD: Single LazyColumn with multiple item / items DSL blocks
LazyColumn(modifier = Modifier.fillMaxSize()) {
    item { HeaderView() }
    items(servers, key = { it.id }) { server ->
        ServerRow(server = server)
    }
}
```

---

## 5. Zero Heavy Allocations in Item Composables

Never execute the following inside item composables:
- `SimpleDateFormat` / `DateTimeFormatter` instantiation
- Regex matching or JSON parsing
- Sorting / filtering collections (`list.filter { }.sortedBy { }`)

**Rule:** Pre-compute all display strings, icons, and formatted timestamps inside the `ViewModel` / `Reducer` before updating `UiState`.

---

## 6. Scroll State & Scroll-to-Top Optimization

```kotlin
val listState = rememberLazyListState()
val scope = rememberCoroutineScope()

// Defer state calculation using derivedStateOf to prevent excessive recomposition
val showScrollToTop by remember {
    derivedStateOf { listState.firstVisibleItemIndex > 3 }
}

LazyColumn(state = listState) {
    items(servers, key = { it.id }) { server ->
        ServerRow(server = server)
    }
}

if (showScrollToTop) {
    ScrollToTopFab(
        onClick = {
            scope.launch { listState.animateScrollToItem(0) }
        }
    )
}
```
