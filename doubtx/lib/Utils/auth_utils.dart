import 'package:flutter/material.dart';

class AuthWidgets {
  // Text Field Widget
  static Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    bool hideText = true,
    Function()? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(prefixIcon, color: Colors.grey,),
        suffixIcon: isPassword 
            ? IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(hideText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              ) 
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Color(0xff232627),
      ),
      obscureText: isPassword ? hideText : false,
      keyboardType: keyboardType,
    );
  }

  // Error Text Widget
  static Widget buildErrorText(String? errorText, double screenWidth) {
    if (errorText == null) return const SizedBox(height: 5);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          errorText,
          style: TextStyle(
            fontSize: screenWidth * (12 / 375),
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  // Action Button Widget
  static Widget buildActionButton({
    required String text,
    required Function() onPressed,
    required bool isLoading,
    required double screenWidth,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff11A8AE),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: screenWidth * (16 / 375),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }

  // Link Row Widget
  static Widget buildLinkRow({
    required String text,
    required String linkText,
    required Function() onPressed,
    required double screenWidth,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * (16 / 375),
            color: Colors.grey,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            linkText,
            style: TextStyle(
              fontSize: screenWidth * (16 / 375),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// Text Styles
class AuthTextStyles {
  static TextStyle getTitleStyle(double screenWidth) => TextStyle(
    fontSize: screenWidth * (30 / 375),
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle getBodyStyle(double screenWidth) => TextStyle(
    fontSize: screenWidth * (16 / 375),
  );

  static TextStyle getErrorStyle(double screenWidth) => TextStyle(
    fontSize: screenWidth * (16 / 375),
    color: Colors.red,
  );

  static TextStyle getButtonTextStyle(double screenWidth) => TextStyle(
    fontSize: screenWidth * (16 / 375),
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}

// Form Validation
class AuthValidation {
  static String? validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Please enter your $fieldName";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    
    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email address";
    }
    
    return null;
  }
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your username";
    }    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    
    // Optional: Add password strength validation here
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    
    return null;
  }

  static String? validatePasswordMatch(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return "Please confirm your password";
    }
    
    if (password != confirmPassword) {
      return "Passwords do not match";
    }
    
    return null;
  }
}

// Auth Common Styles and Constants
class AuthCommon {
  static const Color bgColor = Color(0xff141718);
  static const Color primaryColor = Colors.blue;
  static const Color errorColor = Colors.red;
  
  static const double defaultPadding = 24.0;
  static const double standardSpacing = 10.0;
  static const double smallSpacing = 5.0;
  static const double largeSpacing = 40.0;
  
  static BorderRadius defaultBorderRadius = BorderRadius.circular(12);
  
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: defaultBorderRadius,
    ),
  );
  
  // Standard loading delay
  static const Duration loadingDelay = Duration(milliseconds: 300);
}