//
//  ViewController.swift
//  OptionsComponent
//
//  Created by Aastha Poddar on 19/07/23.
//

import UIKit
import CustomUIDesign

class ViewController: UIViewController {
    var countryList = ["Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia &amp; Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre &amp; Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts &amp; Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad &amp; Tobago","Tunisia","Turkey","Turkmenistan","Turks &amp; Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]
    
    @IBOutlet weak var firstView: CustomTextField!
    @IBOutlet weak var secondView: CustomMultipleSelectionComponent!
    @IBOutlet weak var secondViewHeightConstraint: NSLayoutConstraint!
    
    var selectedCountry: String?
    var selectedCountries: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstView.titleLabel.text = "Single Option Selection"
        secondView.titleLabel.text = "Multiple Option Selection"
        
        firstView.optionSelected.setTitle(selectedCountry ?? "Select a single value", for: .normal)
        secondView.optionSelected.setTitle("Choose more options", for: .normal)
        
        firstView.errorLabel.text = "This field can't be empty"
        secondView.errorLabel.text = "This field can't be empty"
        firstView.errorLabel.isHidden = true
        secondView.errorLabel.isHidden = true
        
        
        firstView.optionSelected.addTarget(self, action: #selector(optionSelectedTapped(_:)), for: .touchUpInside)
        secondView.optionSelected.addTarget(self, action: #selector(optionSelectedTapped(_:)), for: .touchUpInside)
        
        parseJSON()
        
    }
    
    @objc func optionSelectedTapped(_ sender: UIButton) {
        if sender == firstView.optionSelected {
            let frameworkBundle = Bundle(for: SingleOptionSelectionViewController.self)
            let destinationVC = SingleOptionSelectionViewController(nibName: "SingleOptionSelectionViewController", bundle: frameworkBundle)
            destinationVC.country = selectedCountry
            destinationVC.countryList = countryList
            destinationVC.delegate = self
            navigationController?.pushViewController(destinationVC, animated: true)
        }
        if sender == secondView.optionSelected {
            let frameworkBundle = Bundle(for: MultipleOptionSelectionViewController.self)
            let destinationVC = MultipleOptionSelectionViewController(nibName: "MultipleOptionSelectionViewController", bundle: frameworkBundle)
            destinationVC.countryList = countryList
            destinationVC.delegate = self
            if let initialSelectedIndices = selectedCountries?.compactMap({ countryList.firstIndex(of: $0) }) {
                        destinationVC.initiallySelectedRows = Set(initialSelectedIndices)
                    }
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    private func parseJSON() {
        guard let path = Bundle.main.path(forResource: "country-by-name", ofType: "json") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        var country: [Countries]?
        do {
            let jsonData = try Data(contentsOf: url)
            country = try JSONDecoder().decode([Countries].self, from: jsonData)
            
            if let country = country {
                print("country")
            }else {
                print("Error")
            }
            return
        }
        catch {
            print("Error: \(error)")
        }
    }
}
    
extension ViewController: SelectedValueDelegate {
    func didSelectRow(with content: String?) {
        selectedCountry = content
        firstView.optionSelected.setTitle(content, for: .normal)
        checkIfCountrySelected(content: selectedCountry)
    }
    
    func checkIfCountrySelected(content: String?) {
        if(content != nil) {
            firstView.optionSelected.layer.borderColor = UIColor.green.cgColor
            firstView.errorLabel.isHidden = true
        }else {
            firstView.errorLabel.isHidden = false
            firstView.optionSelected.layer.borderColor = UIColor.red.cgColor
        }
    }
}

extension ViewController: SelectedValuesDelegate {
    func didSelectRow(with content: [String]) {
//        selectedCountries = content
//        secondView.updateSelectedData(selectedData: content)
        if let existingSelectedCountries = selectedCountries {
            selectedCountries = Array(Set(existingSelectedCountries).union(content))
        } else {
            selectedCountries = content
        }
        secondView.cellData = selectedCountries ?? []
        let shouldDisplayClearAll = content.count > 0
        if shouldDisplayClearAll {
            secondView.cellData.append("Clear All")
        }
        print("Collection View Height: \(secondView.collectionView.contentSize.height)")
        let height = secondView.calculateCollectionViewTotalHeight()
        secondView.collectionViewHeightConstraint.constant = height
        secondViewHeightConstraint.constant = 218 + height
        print("Collection View total height: \(height)")
        secondView.collectionView.reloadData()
        checkIfCountriesSelected(content: selectedCountries)

    }
    
    func checkIfCountriesSelected(content: [String]?) {
        if(content != nil) {
            secondView.optionSelected.layer.borderColor = UIColor.green.cgColor
            secondView.errorLabel.isHidden = true
        }else {
            secondView.errorLabel.isHidden = false
            secondView.optionSelected.layer.borderColor = UIColor.red.cgColor
        }
    }
}







