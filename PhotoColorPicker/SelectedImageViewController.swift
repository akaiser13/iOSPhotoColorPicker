//
//  SelectedImageViewController.swift
//  PhotoColorPicker
//
//  Created by Kaiser, Austin on 9/29/17.
//  Copyright © 2017 Kaiser, Austin. All rights reserved.
//

import UIKit

class SelectedImageViewController: UIViewController {

    @IBOutlet weak var selectedImageView: UIImageView!

    var image: UIImage!
    
    
    var colors = [ColorHandler]()
    
    let segueToColorTableView = "ColorTableViewControllerSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToColorTableView {
            if let destination = segue.destination as? ColorViewController {
                destination.colors = self.colors
            
            }
        }
    }
    
    @IBAction func openColorBrowser(_ sender: UIButton) {
        
        performSegue(withIdentifier: segueToColorTableView, sender: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: view) {
            let color = selectedImageView.getPixelColorAtPoint(point: point)
            let colorHandler =  ColorHandler(color, image: image)
            
            colors.append(colorHandler)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            selectedImageView.image = image
            selectedImageView.contentMode = .scaleAspectFill
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



    

