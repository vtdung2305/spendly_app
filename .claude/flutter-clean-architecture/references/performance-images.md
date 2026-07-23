# Performance & Images

## Nguyên tắc chung — luôn tối ưu

- `const` widget mọi nơi có thể — giảm rebuild.
- `RepaintBoundary` quanh widget vẽ phức tạp hoặc animation riêng biệt để tránh repaint lan ra
  cả cây widget cha.
- Lazy list: `ListView.builder`/`GridView.builder`, **không** dùng `ListView(children: [...])`
  với data động dài.
- Image cache: luôn dùng `CachedNetworkImage`, không tự quản lý cache thủ công.
- Pagination: infinite scroll load thêm khi gần cuối danh sách, không load hết 1 lần nếu data lớn.
- Debounce cho search input, throttle cho scroll listener bắn liên tục.
- Memoization: tránh tính toán lại giá trị nặng trong `build()` — cache kết quả nếu input không đổi.

```dart
// BAD — build() tính toán nặng mỗi lần rebuild
@override
Widget build(BuildContext context) {
  final sorted = items..sort((a, b) => a.price.compareTo(b.price)); // ❌ sort lại mỗi rebuild
  return ListView.builder(...);
}

// GOOD — tính 1 lần, cache trong ViewModel/state
class HomeState {
  const HomeState({required this.sortedItems});
  final List<Item> sortedItems; // đã sort sẵn khi state được tạo
}
```

## Lazy List + Pagination

```dart
class ProductListView extends ConsumerWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productListViewModelProvider);
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
          ref.read(productListViewModelProvider.notifier).loadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const AppLoadingIndicator();
          }
          return ProductCard(product: state.items[index]);
        },
      ),
    );
  }
}
```

## Debounce Search

```dart
class SearchDebouncer {
  SearchDebouncer({this.duration = const Duration(milliseconds: 400)});
  final Duration duration;
  Timer? _timer;

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void dispose() => _timer?.cancel();
}
```

## Images — `CachedNetworkImage` bắt buộc

```dart
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => const AppImagePlaceholder(),
  errorWidget: (context, url, error) => const AppImageErrorPlaceholder(),
  fadeInDuration: AppAnimation.fast,
)
```

Luôn có `placeholder` (skeleton/shimmer) và `errorWidget` — không để `Image.network` trần không
xử lý lỗi/loading, sẽ crash UI khi network chậm hoặc URL lỗi.

## RepaintBoundary cho animation phức tạp

```dart
RepaintBoundary(
  child: AnimatedContainer(
    duration: AppAnimation.normal,
    // ...
  ),
)
```

## Checklist Performance trước khi output code

- [ ] Widget const hoá tối đa
- [ ] List builder thay vì list children cứng cho data động
- [ ] Có pagination nếu data có thể lớn (>50 item)
- [ ] Image dùng CachedNetworkImage với placeholder/error
- [ ] Search/filter input có debounce
- [ ] Không tính toán nặng lặp lại trong `build()`
