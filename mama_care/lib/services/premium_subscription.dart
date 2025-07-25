import 'package:flutter/material.dart';
import 'package:mama_care/constants/app_colors.dart';

class PremiumSubscriptionPage extends StatelessWidget {
  const PremiumSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Subscription'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Premium Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                children: [
                  const Icon(
                    Icons.stars,
                    size: 80,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Unlock Premium Features',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Take your pregnancy journey to the next level',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.withOpacity(AppColors.textOnPrimary, 0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            // Premium Features
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Premium Features',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    icon: Icons.ad_units_rounded,
                    title: 'Ad-Free Experience',
                    description: 'Enjoy the app without any advertisements',
                  ),
                  _buildFeatureCard(
                    icon: Icons.videocam,
                    title: 'Video Consultations',
                    description: 'Connect with healthcare professionals via video call',
                  ),
                  _buildFeatureCard(
                    icon: Icons.article,
                    title: 'Exclusive Content',
                    description: 'Access premium articles and expert advice',
                  ),
                  _buildFeatureCard(
                    icon: Icons.medical_information,
                    title: 'Advanced Health Tracking',
                    description: 'Detailed health analytics and insights',
                  ),
                  _buildFeatureCard(
                    icon: Icons.chat,
                    title: 'Priority Support',
                    description: '24/7 access to customer support',
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Subscription Plans
                  const Text(
                    'Choose Your Plan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Monthly Plan
                  _buildSubscriptionCard(
                    context,
                    title: 'Monthly',
                    price: '\$9.99',
                    period: 'per month',
                    isPopular: false,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Yearly Plan (with discount)
                  _buildSubscriptionCard(
                    context,
                    title: 'Yearly',
                    price: '\$89.99',
                    period: 'per year',
                    isPopular: true,
                    discount: 'Save 25%',
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Terms and Conditions
                  Text(
                    'By subscribing, you agree to our terms and conditions. Subscriptions will auto-renew unless cancelled 24 hours before the renewal date.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.withOpacity(AppColors.primary, 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    required bool isPopular,
    String? discount,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPopular ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isPopular 
                ? AppColors.withOpacity(AppColors.primary, 0.3)
                : AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isPopular) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPopular ? AppColors.textOnPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isPopular ? AppColors.textOnPrimary : AppColors.textPrimary,
            ),
          ),
          Text(
            period,
            style: TextStyle(
              fontSize: 14,
              color: isPopular 
                  ? AppColors.withOpacity(AppColors.textOnPrimary, 0.8)
                  : AppColors.textLight,
            ),
          ),
          if (discount != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                discount,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleSubscription(context, title),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? Colors.white : AppColors.primary,
                foregroundColor: isPopular ? AppColors.primary : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Subscribe to ${title.toLowerCase()} plan'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscription(BuildContext context, String plan) {
    // TODO: Implement actual payment processing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Subscription'),
        content: Text('Would you like to subscribe to the $plan plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$plan subscription will be available soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}
