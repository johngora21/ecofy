export interface Farm {
  id: number;
  name: string;
  location: string;
  size: string;
  sizeInAcres: number;
  image: string;
  soilMoisture: string;
  organicCarbon: string;
  soilTexture: string;
  soilPH: string;
  ec: string;
  salinity: string;
  waterHoldingCapacity: string;
  organicMatter: string;
  npk: string;
  crops: string[];
  latitude: string;
  longitude: string;
  topography: string;
}

export type ModalType = 'view' | 'edit' | 'add' | 'delete' | null;
export type ViewTab = 'Farm Maps' | 'Soil Reports' | 'Resources' | 'Recommendations';