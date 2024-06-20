part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductInProgress extends ProductState {
  final int progress;
  const ProductInProgress(this.progress);
  @override
  List<Object> get props => [progress];

  ProductInProgress copyWith({
    int? progress,
  }) {
    return ProductInProgress(
      progress ?? this.progress,
    );
  }
}

final class ProductLoading extends ProductState {}

final class ProductSuccess extends ProductState {
  final List<ProductModel> products;
  const ProductSuccess(this.products);
  @override
  List<Object> get props => [products];

  ProductSuccess copyWith({
    List<ProductModel>? products,
  }) {
    return ProductSuccess(
      products ?? this.products,
    );
  }
}

final class ProductError extends ProductState {
  final String error;
  const ProductError(this.error);
  @override
  List<Object> get props => [error];
}
