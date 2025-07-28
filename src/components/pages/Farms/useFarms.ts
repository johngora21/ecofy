import { useState } from 'react';
import type { Farm, ModalType, ViewTab } from '../../../types/farm';
import { initialFarms } from '../../../data/farmsData';

export const useFarms = () => {
  const [farms, setFarms] = useState<Farm[]>(initialFarms);
  const [selectedFarm, setSelectedFarm] = useState<Farm | null>(null);
  const [modalType, setModalType] = useState<ModalType>(null);
  const [activeTab, setActiveTab] = useState<ViewTab>('Farm Maps');
  const [formData, setFormData] = useState<Partial<Farm>>({});

  const openViewModal = (farm: Farm) => {
    setSelectedFarm(farm);
    setActiveTab('Farm Maps');
    setModalType('view');
  };

  const openEditModal = (farm: Farm) => {
    setSelectedFarm(farm);
    setFormData(farm);
    setModalType('edit');
  };

  const openAddModal = () => {
    setSelectedFarm(null);
    setFormData({
      name: '',
      location: '',
      sizeInAcres: 0,
      image: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&h=200&fit=crop',
      soilMoisture: '',
      organicCarbon: '',
      soilTexture: '',
      soilPH: '',
      crops: [],
      latitude: '',
      longitude: '',
      topography: ''
    });
    setModalType('add');
  };

  const openDeleteModal = (farm: Farm) => {
    setSelectedFarm(farm);
    setModalType('delete');
  };

  const closeModal = () => {
    setModalType(null);
    setSelectedFarm(null);
    setFormData({});
  };

  const saveFarm = () => {
    if (selectedFarm) {
      // Update existing farm
      setFarms(farms.map(farm => 
        farm.id === selectedFarm.id 
          ? { ...formData, id: selectedFarm.id, size: `${formData.sizeInAcres} acres` } as Farm
          : farm
      ));
    } else {
      // Add new farm
      const newFarm: Farm = {
        ...formData,
        id: Date.now(),
        size: `${formData.sizeInAcres} acres`
      } as Farm;
      setFarms([...farms, newFarm]);
    }
    closeModal();
  };

  const deleteFarm = () => {
    if (selectedFarm) {
      setFarms(farms.filter(farm => farm.id !== selectedFarm.id));
      closeModal();
    }
  };

  return {
    farms,
    selectedFarm,
    modalType,
    activeTab,
    formData,
    openViewModal,
    openEditModal,
    openAddModal,
    openDeleteModal,
    closeModal,
    saveFarm,
    deleteFarm,
    setActiveTab,
    setFormData,
    setSelectedFarm,
    setModalType,
    setFarms
    };
}