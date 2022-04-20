//
//  CommentView.swift
//  PlugSpace
//
//  Created by Gopal Krishan on 20/04/22.
//

import SwiftUI


func presentCommentView(from vc: UIViewController, commentTapped: @escaping ((String) -> Void)) {
    let vc2 = UIHostingController(rootView: CommentView(dismissAction: {
        vc.presentedViewController?.dismiss( animated: true, completion: nil)
    }, commentTapped: { comment  in
        if (comment.trimmed().isEmpty) {
            vc.presentedViewController?.alertWith(message: "Please add comment")
        } else {
            commentTapped(comment)
            vc.presentedViewController?.dismiss( animated: true, completion: nil)
        }
    }))
    vc2.modalPresentationStyle = .overFullScreen
    vc2.modalTransitionStyle = .crossDissolve
    vc2.view.backgroundColor = .clear
    vc.present(vc2, animated: false, completion: nil)
    
}

struct CommentView: View {
    @State var comment = ""
    var dismissAction: (() -> Void)
    var commentTapped: ((String) -> Void)
    var body: some View {
        VStack {
         Spacer()
            VStack {
                Text(AppName)
                    .font(.system(size: 18, weight: .bold))
                Text("Please add comment")
                TextView(text: $comment)
                .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 60, alignment: .leading)
                .shadow(radius: 1)
                HStack {
                    Button {
                        commentTapped(comment)
                    } label: {
                        Text("Comment")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: dismissAction) {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .padding()
            
        }
        .background(Color.black.opacity(0.2).edgesIgnoringSafeArea(.all))
        
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(dismissAction: {
            
        }, commentTapped: { comment  in
            
        })
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        func makeUIView(context: Context) -> UITextView {

            let myTextView = UITextView()
            myTextView.delegate = context.coordinator

            myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
            myTextView.isScrollEnabled = true
            myTextView.isEditable = true
            myTextView.isUserInteractionEnabled = true
            myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)

            return myTextView
        }

        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.text = text
        }

        class Coordinator : NSObject, UITextViewDelegate {

            var parent: TextView

            init(_ uiTextView: TextView) {
                self.parent = uiTextView
            }

            func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                return true
            }

            func textViewDidChange(_ textView: UITextView) {
                self.parent.text = textView.text
            }
        }
}
