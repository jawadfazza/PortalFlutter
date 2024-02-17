import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Models/Store.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final VoidCallback onTap;
  final int layoutNumber;

  const StoreCard({
    required this.store,
    required this.onTap,
    required this.layoutNumber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: layoutNumber == 1
          ? _buildCardLayoutOne()
          : _buildCardLayoutTwo(),
    );
  }

  Widget _buildCardLayoutOne() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageContainer(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameAndDescription(),
                const SizedBox(height: 8),
                _buildRatingInfo(),
                const SizedBox(height: 8),
                _buildAdditionalInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardLayoutTwo() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildImageContainer(),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameAndDescription(),
                  const SizedBox(height: 8),
                  _buildPrice(),
                  const SizedBox(height: 8),
                  _buildAdditionalInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      width: layoutNumber == 1 ? double.infinity : 120,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(store.imageURL),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildNameAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          store.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          store.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingInfo() {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Rating: ${currencyFormat.format(store.rating)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${store.rating.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location: ${store.location}',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          'Contact: ${store.contactNumber}',
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          'Active: ${store.active ? 'Yes' : 'No'}',
          style: const TextStyle(fontSize: 12),
        ),
        // Add more information based on your preference
        // You can include opening hours, email, website, etc.
      ],
    );
  }
}








