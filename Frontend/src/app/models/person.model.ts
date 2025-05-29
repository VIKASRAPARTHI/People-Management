export interface Person {
  id?: number;
  name: string;
  age: number;
  gender: string;
  mobileNumber: string;
  createdAt?: string;
  updatedAt?: string;
}

// Interface for API response from JSONPlaceholder
export interface ApiUser {
  id: number;
  name: string;
  username: string;
  email: string;
  phone: string;
  website: string;
  address: {
    street: string;
    suite: string;
    city: string;
    zipcode: string;
    geo: {
      lat: string;
      lng: string;
    };
  };
  company: {
    name: string;
    catchPhrase: string;
    bs: string;
  };
}

export interface PersonCreateRequest {
  name: string;
  age: number;
  gender: string;
  mobileNumber: string;
}

export interface PersonUpdateRequest {
  name?: string;
  age?: number;
  gender?: string;
  mobileNumber?: string;
}
