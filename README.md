# Custom Toasts with SwiftUI


Custom Toasts is so cool!

I built a flexible and stylish toast modifier with SwiftUI using @Kavsoft's interactive toasts. 😄🔥

This project showcases how to create reusable, animated, and customizable toast notifications for SwiftUI apps – perfect for alerts, actions, or just a bit of UI flair.


🚀 Features

   1. Fully custom ViewModifier for reusable toasts

   2. Smooth animations and transitions

   3. Support for multiple toast types (info, success, error, etc.)

   4. Interactive gestures thanks to Kavsoft’s toast system

   5. Lightweight, SwiftUI-native


📸 Preview

https://github.com/user-attachments/assets/c317b22c-03df-4a13-b8ff-1c8749372359


🛠 Usage
Add the Modifier

    var body: some View {
        NavigationStack {
            List {
                Section("Toaster Examples") {
                    Button {
                        vm.showSuccessToaster()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Success")
                        }
                        .foregroundStyle(.green)
                    }
                }
            }
            .withToastsMod()
        }
    }


Customize Your Toast

You can easily extend the toast modifier to support:

   1. Icons

   2. Text

   3. Colors

   4. Custom button in toast

   5. Auto-dismiss timers

   6. Interactive swipe-to-dismiss


💬 Why I Built This

I love SwiftUI’s declarative style – but sometimes, native alerts or notifications can feel limited. So I crafted this system to be:

✨ Minimal • 💡 Flexible • 🔁 Reusable • 😄 So Fun


🧪 Coming Soon

   1. Light/Dark mode support

   2. More animation styles

   3. Queueing multiple toasts

   4. SPM-ready package (optional)


📄 License

MIT – use it, fork it, toast it up.
