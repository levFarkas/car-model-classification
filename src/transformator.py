from typing import Tuple
from torchvision.transforms import transforms
from torchvision.datasets.folder import ImageFolder
from torch.utils.data.dataloader import DataLoader


def transform(train_data_path: str, val_data_path: str, test_data_path: str) -> Tuple[list, list, list]:
    # Training transform includes random rotation and flip to build a more robust model
    train_transforms = transforms.Compose([transforms.Resize((244, 244)),
                                           transforms.RandomRotation(30),
                                           transforms.RandomHorizontalFlip(),
                                           transforms.ToTensor(),
                                           transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])

    # The validation set will use the same transform as the test set
    test_transforms = transforms.Compose([transforms.Resize((244, 244)),
                                          transforms.CenterCrop(224),
                                          transforms.ToTensor(),
                                          transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])

    validation_transforms = transforms.Compose([transforms.Resize((244, 244)),
                                                transforms.CenterCrop(224),
                                                transforms.ToTensor(),
                                                transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))])

    # Load the datasets with ImageFolder
    train_data = ImageFolder(train_data_path, transform=train_transforms)
    test_data = ImageFolder(test_data_path, transform=test_transforms)
    valid_data = ImageFolder(test_data_path, transform=validation_transforms)

    # Using the image datasets and the trainforms, define the dataloaders
    # The trainloader will have shuffle=True so that the order of the images do not affect the model
    trainloader = DataLoader(train_data, batch_size=128, shuffle=True)
    testloader = DataLoader(test_data, batch_size=32, shuffle=True)
    validloader = DataLoader(valid_data, batch_size=32, shuffle=True)
