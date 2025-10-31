# Razorpay SDK rules
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Annotations used by Razorpay
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers
-keepattributes *Annotation*
-dontwarn proguard.annotation.**
