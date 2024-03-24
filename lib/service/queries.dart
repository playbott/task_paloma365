import 'package:sqflite/sqflite.dart' as sqlite;

Future<List<Map<String, dynamic>>> getProducts(sqlite.Database db) async {
  List<Map<String, dynamic>>? data =
      await db.rawQuery('SELECT * FROM products');

  return data;
}

Future<List<Map<String, dynamic>>> getOrders(sqlite.Database db) async {
  List<Map<String, dynamic>>? data = await db.rawQuery('''
select o.id as id, o.place as place, coalesce(c.summary, 0.0) as price_summary, o.created_at as created_at
from orders o
   left join (select c.order_id, sum(p.price*c.count) summary
              from cart c
                       left join products p on c.product_id = p.id
              group by c.order_id) c on c.order_id = o.id
              --where coalesce(c.summary, 0.0) > 0
  order by id desc;
    ''');

  return data;
}

Future<List<Map<String, dynamic>>> getCartProducts(
    sqlite.Database db, int orderId) async {
  List<Map<String, dynamic>>? data = await db.rawQuery('''
select c.id as cart_id, p.name, p.price, c.count, c.product_id
from cart c
        cross join products p on c.product_id = p.id
where c.order_id = $orderId
order by c.id DESC;
    ''');

  return data;
}

Future<int> createOrder(
  sqlite.Database db, {
  required String place,
}) async {
  final id = await db.rawInsert(
      "INSERT INTO orders (place, created_at) VALUES ('$place', '${DateTime.now().toIso8601String()}')");

  return id;
}

Future<void> updateCartProductCount(
  sqlite.Database db, {
  required int cartProductId,
  required int count,
}) async {
  if (count <= 0) {
    await db.rawDelete("delete from cart where id = $cartProductId;");
  } else {
    await db
        .rawUpdate("update cart set count = $count where id = $cartProductId;");
  }
}

Future<void> insertCartProduct(
  sqlite.Database db, {
  required int productId,
  required int orderId,
}) async {
  await db.transaction((txn) async {
    int count = sqlite.Sqflite.firstIntValue(await txn.rawQuery(
            'select count(*) as cnt from cart where order_id = $orderId and product_id = $productId;')) ??
        0;
    if (count <= 0) {
      await txn.rawUpdate(
          "insert or ignore into cart(product_id, order_id, count) values ($productId, $orderId, 1);");
    } else {
      await txn.rawUpdate(
          "update cart set count = (select count+1 from cart where product_id = $productId and order_id = $orderId) where order_id = $orderId and product_id = $productId;");
    }
    return;
  });
}
