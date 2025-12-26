class Blog {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;

  Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.date,
  });
}

// Dummy Data
List<Blog> dummyBlogs = [
  Blog(
    id: '1',
    title: 'Coffee Origins: A Journey Through Time',
    content: 'Coffee has a rich history dating back to the 9th century...',
    imageUrl: 'https://example.com/coffee1.jpg',
    date: DateTime(2025, 10, 15),
  ),
  Blog(
    id: '2',
    title: 'The Art of Coffee Brewing',
    content: 'Different brewing methods can bring out various flavors...',
    imageUrl: 'https://example.com/coffee2.jpg',
    date: DateTime(2025, 10, 20),
  ),
];
