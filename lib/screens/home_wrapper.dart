import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'product_details_wrapper.dart';
import 'cart_screen.dart';
import 'payment_selection_screen.dart';
import 'checkout_success_screen.dart';
import 'login_page.dart';
import 'address_screen.dart';
import 'orders_screen.dart';
import 'profile_detail_screen.dart';
import '../main.dart';


// ...




import '../services/auth_service.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/product_service.dart';
import '../services/firestore_service.dart';
import '../services/note.dart';
import '../utils/app_spacing.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final ProductService _productService = ProductService();
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  
  List<Product> allProducts = [];
  List<Product> products = [];
  Set<int> favoriteProductIds = {};
  Map<String, CartItem> cartItems = {}; // key: productId_size
  bool isLoading = true;
  int _currentNavigationIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _initFirestoreListeners();
  }

  void _initFirestoreListeners() {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      // Listen to favorites
      _firestoreService.getFavorites(uid).listen((ids) {
        if (mounted) setState(() => favoriteProductIds = ids.toSet());
      });

      // Listen to cart
      _firestoreService.getCart(uid).listen((snapshot) {
        if (mounted) {
          final newCart = <String, CartItem>{};
          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();
              final productId = data['productId'] as int;
              // Safely find product
              final product = allProducts.firstWhere(
                (p) => p.id == productId,
                orElse: () => Product(id: productId, title: 'Unknown Product', description: '', price: 0.0, images: []),
              );
              
              newCart[doc.id] = CartItem(
                product: product,
                productId: productId.toString(),
                size: data['size'] as String? ?? 'N/A',
                quantity: data['quantity'] as int? ?? 1,
              );
            } catch (e) {
              print('Error parsing cart item: $e');
            }
          }
          setState(() => cartItems = newCart);
        }
      });
    }
  }

  Future<void> _loadProducts() async {
    try {
      final fetchedProducts = await _productService.fetchProducts();
      setState(() {
        allProducts = fetchedProducts;
        products = fetchedProducts;
        isLoading = false;
      });
      // Re-initialize listeners if products were slow to load
      _initFirestoreListeners();
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        allProducts = [];
        products = [];
        isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(Product product) async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      try {
        await _firestoreService.toggleFavorite(uid, product.id);
      } catch (e) {
        print('Toggle favorite error: $e');
      }
    }
  }

  Future<void> _addToCart(Product product, String size) async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      try {
        await _firestoreService.addToCart(uid, product.id, size, 1);
      } catch (e) {
        print('Add to cart error: $e');
      }
    }
  }

  Future<void> _removeFromCart(String key) async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      try {
        await _firestoreService.removeFromCart(uid, key);
      } catch (e) {
        print('Remove from cart error: $e');
      }
    }
  }

  Future<void> _updateCartItemQuantity(String key, int newQuantity) async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      try {
        if (newQuantity <= 0) {
          await _firestoreService.removeFromCart(uid, key);
        } else {
          await _firestoreService.updateCartQuantity(uid, key, newQuantity);
        }
      } catch (e) {
        print('Update quantity error: $e');
      }
    }
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() => products = allProducts);
      return;
    }

    final queryLower = query.toLowerCase();
    setState(() {
      products = allProducts.where((product) {
        final title = product.title.toLowerCase();
        final desc = product.description.toLowerCase();
        return title.contains(queryLower) || desc.contains(queryLower);
      }).toList();
    });
  }

  double get _cartTotal {
    return cartItems.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get _cartItemCount {
    return cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  }

  void _openProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsWrapper(
          product: product,
          title: product.title,
          subtitle: 'Laza Collection',
          description: product.description,
          price: '\$${product.price}',
          imageUrls: product.images,
          isFavorite: favoriteProductIds.contains(product.id),
          sizes: const ['S', 'M', 'L', 'XL'],
          onToggleFavorite: () {
            _toggleFavorite(product);
            // Pop and push to refresh the screen with updated favorite state
            Navigator.pop(context);
            _openProductDetails(product);
          },
          onAddToCart: (size) => _addToCart(product, size),
          onGoToCart: () => _onNavigationChanged(2),
        ),
      ),
    );
  }

  List<Product> get _favoriteProducts {
    return products.where((p) => favoriteProductIds.contains(p.id)).toList();
  }

  void _onNavigationChanged(int index) {
    setState(() {
      _currentNavigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }


    // Handle navigation based on current index
    switch (_currentNavigationIndex) {
      case 1: // Favorites
        return _buildFavoritesScreen();
      case 2: // Cart
        return _buildCartScreen();
      case 3: // Profile
        return _buildProfileScreen();
      default: // Home
        return _buildHomeScreen();
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'theme':
        LazaApp.of(context).toggleTheme();
        break;
      case 'profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileDetailScreen()),
        );
        break;
      case 'orders':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrdersScreen()),
        );
        break;
      case 'favorites':
        _onNavigationChanged(1);
        break;
      case 'logout':
        _authService.logout();
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/welcome',
          (route) => false,
        );
        break;
    }
  }

  Widget _buildHomeScreen() {
    return HomeScreen(
      products: products,
      titleBuilder: (p) => p.title,
      subtitleBuilder: (p) => p.description,
      priceBuilder: (p) => '\$${p.price}',
      imageBuilder: (p) => p.images.isNotEmpty ? p.images[0] : null,
      favoriteBuilder: (p) => favoriteProductIds.contains(p.id),
      onProductTap: _openProductDetails,
      onFavoriteToggle: _toggleFavorite,
      navigationIndex: _currentNavigationIndex,
      onNavigationChanged: _onNavigationChanged,
      onOpenCart: () => _onNavigationChanged(2),
      onOpenFavorites: () => _onNavigationChanged(1),
      onOpenProfile: () => _onNavigationChanged(3),
      onSearchChanged: _handleSearch,
      onMenuAction: _handleMenuAction,
    );
  }

  Widget _buildFavoritesScreen() {
    return Scaffold(
      body: FavoritesScreen(
        favorites: _favoriteProducts,
        titleBuilder: (p) => p.title,
        subtitleBuilder: (p) => p.description,
        priceBuilder: (p) => '\$${p.price}',
        imageBuilder: (p) => p.images.isNotEmpty ? p.images[0] : null,
        onProductTap: _openProductDetails,
        onToggleFavorite: _toggleFavorite,
        onBack: () => _onNavigationChanged(0),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  Widget _buildCartScreen() {
    final cartItemList = cartItems.values.toList();
    return Scaffold(
      body: CartScreen(
        cartItems: cartItemList,
        onRemove: _removeFromCart,
        onUpdateQuantity: _updateCartItemQuantity,
        onCheckout: () async {
          if (cartItems.isEmpty) return;

          // 1. Confirm/Add Address
          final addressResult = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddressScreen()),
          );

          if (addressResult != true) return;

          if (context.mounted) {
            // 2. Payment - Pass cart items for order creation
            final cartItemList = cartItems.values.toList();
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSelectionScreen(
                  totalAmount: _cartTotal,
                  cartItems: cartItemList,
                ),
              ),
            );
            
            if (result == true && context.mounted) {
              _clearCart();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutSuccessScreen(
                    title: 'Order Placed!',
                    message: 'Your order was placed successfully. For more details, check Delivery Status.',
                    buttonLabel: 'Continue Shopping',
                    onContinue: () {
                       if (context.mounted) {
                         Navigator.pop(context); // Pop Success Screen
                         _onNavigationChanged(0); // Go to Home
                       }
                    },
                  ),
                ),
              );
            }
          }
        },
        onBack: () => _onNavigationChanged(0),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildProfileScreen() {
    final theme = Theme.of(context);
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _onNavigationChanged(0),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Profile'),
        actions: [
           IconButton(
             onPressed: () async {
               await AuthService().logout();
               if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
               }
             },
             icon: const Icon(Icons.logout),
             tooltip: 'Logout',
           ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile info section
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person_outline,
                    size: 32,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<String?>(
                        future: AuthService().getUserName(),
                        builder: (context, snapshot) {
                          final name = snapshot.data ?? 'User';
                          return Text(
                            name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AuthService().currentUser?.email ?? 'No Email',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Notes section header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Firebase Notes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Add a test note
                    firestoreService.addNote(Note(
                      title: 'Test Note ${DateTime.now().millisecondsSinceEpoch}',
                      content: 'This is a test note created at ${DateTime.now()}',
                      updatedAt: DateTime.now(),
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Test note added!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add Test Note',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Notes list from Firebase
            Expanded(
              child: StreamBuilder<List<Note>>(
                stream: firestoreService.getNotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading notes',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final notes = snapshot.data ?? [];
                  
                  if (notes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notes yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add a test note',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Text(
                            note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () {
                              if (note.id != null) {
                                firestoreService.deleteNote(note.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Note deleted'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBar(
      selectedIndex: _currentNavigationIndex,
      onDestinationSelected: _onNavigationChanged,
      destinations: [
        const NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        const NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Favorites'),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: _cartItemCount > 0,
            label: Text('$_cartItemCount'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
          label: 'Cart',
        ),
        const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}
