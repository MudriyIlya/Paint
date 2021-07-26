import UIKit

final class ToolsCollectionViewCell: UICollectionViewCell {
	private lazy var toolImageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.borderWidth = 1
		view.layer.backgroundColor = UIColor.black.cgColor
		view.layer.cornerRadius = 30
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
		updateConstraints()
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		contentView.addSubview(toolImageView)
		//backgroundColor = .blue
	}
	
	override func updateConstraints() {
		NSLayoutConstraint.activate([
			toolImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			toolImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			toolImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			toolImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
		
		super.updateConstraints()
	}
	
	func setImage(image: UIImage) {
		toolImageView.image = image
	}
	
	func transformToLarge() {
		UIView.animate(withDuration: 0.2) {
			self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
			self.layer.cornerRadius = self.frame.width / 2
		}
//		let generator = UIImpactFeedbackGenerator(style: .heavy)
//		generator.impactOccurred()
	}
	
	func transformToIdentity() {
		UIView.animate(withDuration: 0.2) {
			self.transform = CGAffineTransform.identity
			self.layer.cornerRadius = self.frame.width / 2
		}
	}
	
	//TEST
	func setColor(_ color: UIColor) {
		toolImageView.backgroundColor = color
	}
}
