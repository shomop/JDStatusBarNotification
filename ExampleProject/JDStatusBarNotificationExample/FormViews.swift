//
//

import SwiftUI

@available(iOS 14.0, *)
struct InfoLabel: View {
  let text: String

  var body: some View {
    HStack {
      Spacer(minLength: 0.0)
      Text(text)
        .font(.caption2)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
      Spacer(minLength: 0.0)
    }.disabled(true)
  }
}

@available(iOS 15.0, *)
struct OptionalColorPicker: View {
  var title: String
  @Binding var color: UIColor?

  var body: some View {
    ColorPicker(title, selection: Binding<CGColor>(get: {
      color?.cgColor ?? UIColor.white.cgColor
    }, set: { val in
      color = UIColor(cgColor: val)
    }))
    .font(.subheadline)
  }
}

struct OptionalColorToggle: View {
  var title: String
  @Binding var color: UIColor?
  var defaultColor: UIColor?

  var body: some View {
    Toggle(title, isOn: Binding(get: {
      color != nil
    }, set: { on in
      color = on ? defaultColor : nil
    }))
    .font(.subheadline)
  }
}

struct CGPointStepper: View {
  var title: String
  @Binding var point: CGPoint

  var body: some View {
    VStack(alignment: .leading, spacing: 6.0) {
      Text("\(title) (\(Int(point.x))/\(Int(point.y)))")
        .font(.subheadline)
      HStack(alignment: .center, spacing: 20.0) {
        Spacer()
        Stepper("X:", value: $point.x)
          .frame(width: 120)
          .font(.subheadline)
        Stepper("Y:", value: $point.y)
          .frame(width: 120)
          .font(.subheadline)
        Spacer()
      }
    }
  }
}

struct SegmentedPicker<T, SomeView>: View where T: Hashable, SomeView: View {
  var title: String
  @Binding var value: T
  @ViewBuilder var content: () -> SomeView

  var body: some View {
    VStack(alignment: .leading, spacing: 6.0) {
      if title.count > 0 {
        Text(title)
          .font(.subheadline)
          .padding(.top, 4.0)
      }
      Picker("", selection: $value) {
        content()
      }.pickerStyle(.segmented)
    }
  }
}

@available(iOS 15.0, *)
struct TextFieldStepper: View {
  var title: String
  var binding: Binding<Double>
  var range: ClosedRange<Double> = -999 ... 999

  @FocusState private var isFocused: Bool

  var body: some View {
    HStack {
      Stepper(title, value: binding, in: range, onEditingChanged: { _ in
        isFocused = false
      })
      .font(.subheadline)
      TextField(value: binding, format: .number) {
        EmptyView()
      }
      .frame(width: 50)
      .textFieldStyle(.roundedBorder)
      .font(.subheadline)
      .focused($isFocused)
      .onChange(of: binding.wrappedValue, perform: { newValue in
        binding.wrappedValue = min(range.upperBound, max(range.lowerBound, newValue))
      })
    }
  }
}

@available(iOS 15.0, *)
struct FormFactory_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      OptionalColorPicker(title: "Color picker", color: .constant(.red))
      OptionalColorToggle(title: "Color resetting toggle", color: .constant(nil), defaultColor: .blue)

      CGPointStepper(title: "CGPoint Control", point: .constant(CGPoint(x: 20, y: 20)))

      SegmentedPicker(title: "Inline Picker", value: .constant(1)) {
        Text("one").tag(1)
        Text("two").tag(2)
        Text("three").tag(3)
      }

      TextFieldStepper(title: "Stepper + Textfield", binding: .constant(23))

      InfoLabel(text: "But let me tell ya, these settings need careful consideration. So better be careful!")
    }
  }
}
