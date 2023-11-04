//
//  TextView.swift
//  Test
//
//  Created by Alan on 2023/11/4.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var input: String
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.backgroundColor = UIColor.yellow
        view.font = UIFont.systemFont(ofSize: 17)
        view.delegate = context.coordinator
        return view
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = input
    }
    func makeCoordinator() -> CoordinatorTextView {
        return CoordinatorTextView(input: $input)
    }
}

class CoordinatorTextView: NSObject, UITextViewDelegate {
    @Binding var inputCoordinator: String
    
    init(input: Binding<String>) {
        self._inputCoordinator = input
    }
    func textViewDidChange(_ textView: UITextView) {
        inputCoordinator = textView.text
    }
}
