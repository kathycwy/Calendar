//
//  DayCell.swift
//  Calendar
//
//  Created by Aparna Joshi on 25/01/22.
//

import UIKit

class DayCell: UITableViewCell
{
    @IBOutlet weak var timeLabel: PaddingLabel!
    @IBOutlet weak var event: PaddingLabel!
    @IBOutlet weak var moreEvents: PaddingLabel!
    @IBOutlet weak var eventView: UIView!
    
    func initCell(indexPath: IndexPath) {
        self.timeLabel.padding(5, 5, 5, 5)
        self.timeLabel.text = ""
        self.timeLabel.font = timeLabel.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.timeLabel.textColor = UIColor.appColor(.onSurface)
        self.event.padding(5, 5, 5, 5)
        self.event.textColor = UIColor.appColor(.onSurface)
        self.event.text = ""
        self.event.font = event.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.event.textColor = UIColor.appColor(.onSurface)
        self.moreEvents.padding(5, 5, 5, 5)
        self.moreEvents.text = ""
        self.moreEvents.font = moreEvents.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.moreEvents.textColor = UIColor.appColor(.onSurface)
        self.event.layer.borderColor = UIColor.appColor(.onSurface)?.cgColor
        self.event.layer.borderWidth = 1
        self.event.backgroundColor = UIColor.appColor(.onSurface)?.withAlphaComponent(0.2)
    }
        
        
}

class TimeCell: UITableViewCell {
    // little "hack" using two labels to render time both above and below the cell
    private let topTimeLabel = UILabel()
    private let bottomTimeLabel = UILabel()

    private let separatorLine = UIView()

    var topTime: String = "" {
        didSet {
            topTimeLabel.text = topTime
        }
    }
    var bottomTime: String = "" {
        didSet {
            bottomTimeLabel.text = bottomTime
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(topTimeLabel)
        contentView.addSubview(bottomTimeLabel)
        contentView.addSubview(separatorLine)


        topTimeLabel.textColor = UIColor.gray
        topTimeLabel.textAlignment = .right
        bottomTimeLabel.textColor = UIColor.gray
        bottomTimeLabel.textAlignment = .right
        separatorLine.backgroundColor = UIColor.gray

        bottomTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        topTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            bottomTimeLabel.centerYAnchor.constraint(equalTo: self.bottomAnchor),
            bottomTimeLabel.widthAnchor.constraint(equalToConstant: 50),
            topTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            topTimeLabel.centerYAnchor.constraint(equalTo: self.topAnchor),
            topTimeLabel.widthAnchor.constraint(equalToConstant: 50),
            separatorLine.leftAnchor.constraint(equalTo: bottomTimeLabel.rightAnchor, constant: 8),
            separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
