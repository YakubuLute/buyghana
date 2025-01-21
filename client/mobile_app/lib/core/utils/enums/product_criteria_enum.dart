enum ProductCriteria {
  newArrivals('New Arrivals'),
  popular('Popular'),
  all('All');

  const ProductCriteria(this.title);

  final String title;
}
