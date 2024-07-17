import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedia_predict/gradient_scaffold.dart';

final _firebase = FirebaseAuth.instance;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _isAuthenticating = false;
  var _isForgotPassword = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isForgotPassword) {
        await _firebase.sendPasswordResetEmail(email: _enteredEmail);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset email sent.'),
            ),
          );
        }
      } else if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        debugPrint("Login successful");

        // Delay to ensure Firebase updates the auth state
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
        });
        debugPrint("Sign up successful");

        // Delay to ensure Firebase updates the auth state
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _isForgotPassword = false;
    });
  }

  void _forgotPassword() {
    setState(() {
      _isForgotPassword = true;
      _isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBarText: "Pedia Predict",
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Email Address'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        if (!_isLogin && !_isForgotPassword)
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 4) {
                                return 'Please enter at least 4 characters.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                        if (!_isForgotPassword)
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                        const SizedBox(height: 12),
                        if (_isAuthenticating)
                          const CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isForgotPassword
                                ? 'Reset Password'
                                : _isLogin
                                    ? 'Login'
                                    : 'Signup'),
                          ),
                        if (!_isAuthenticating && !_isForgotPassword)
                          TextButton(
                            onPressed: _toggleMode,
                            child: Text(_isLogin
                                ? 'Create an account'
                                : 'I already have an account'),
                          ),
                        if (!_isAuthenticating && _isLogin)
                          TextButton(
                            onPressed: _forgotPassword,
                            child: const Text('Forgot Password?'),
                          ),
                        if (_isForgotPassword)
                          TextButton(
                            onPressed: _toggleMode,
                            child: const Text('Back to login'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
