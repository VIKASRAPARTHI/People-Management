import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError, BehaviorSubject } from 'rxjs';
import { catchError, tap, map } from 'rxjs/operators';
import { Person, PersonCreateRequest, PersonUpdateRequest } from '../models/person.model';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class PeopleService {
  private readonly baseUrl = `${environment.apiUrl}/people`; // Backend API
  private peopleSubject = new BehaviorSubject<Person[]>([]);
  public people$ = this.peopleSubject.asObservable();

  constructor(private http: HttpClient) {
    // Load sample data initially
    this.loadPeople();
  }

  // Get all people
  getPeople(): Observable<Person[]> {
    return this.http.get<{success: boolean, data: Person[]}>(this.baseUrl).pipe(
      map(response => {
        const people = response.data || [];
        this.peopleSubject.next(people);
        return people;
      }),
      catchError(this.handleError)
    );
  }

  // Get person by ID
  getPerson(id: number): Observable<Person> {
    return this.http.get<{success: boolean, data: Person}>(`${this.baseUrl}/${id}`).pipe(
      map(response => response.data),
      catchError(this.handleError)
    );
  }

  // Create new person
  createPerson(person: PersonCreateRequest): Observable<Person> {
    return this.http.post<{success: boolean, data: Person}>(this.baseUrl, person).pipe(
      tap(response => {
        // Update local state
        const currentPeople = this.peopleSubject.value;
        this.peopleSubject.next([...currentPeople, response.data]);
      }),
      map(response => response.data),
      catchError(this.handleError)
    );
  }

  // Update person
  updatePerson(id: number, person: PersonUpdateRequest): Observable<Person> {
    return this.http.put<{success: boolean, data: Person}>(`${this.baseUrl}/${id}`, person).pipe(
      tap(response => {
        // Update local state
        const currentPeople = this.peopleSubject.value;
        const index = currentPeople.findIndex(p => p.id === id);
        if (index !== -1) {
          currentPeople[index] = response.data;
          this.peopleSubject.next([...currentPeople]);
        }
      }),
      map(response => response.data),
      catchError(this.handleError)
    );
  }

  // Delete person
  deletePerson(id: number): Observable<any> {
    console.log('PeopleService: Deleting person with ID:', id);

    return this.http.delete<{success: boolean, message: string}>(`${this.baseUrl}/${id}`).pipe(
      tap(() => {
        // Update local state after successful deletion
        const currentPeople = this.peopleSubject.value;
        const filteredPeople = currentPeople.filter(p => p.id !== id);
        this.peopleSubject.next(filteredPeople);
        console.log('Person deleted successfully');
      }),
      catchError(this.handleError)
    );
  }

  private loadPeople(): void {
    this.getPeople().subscribe();
  }

  private handleError(error: HttpErrorResponse) {
    let errorMessage = 'An unknown error occurred!';
    if (error.error instanceof ErrorEvent) {
      // Client-side error
      errorMessage = `Error: ${error.error.message}`;
    } else {
      // Server-side error
      errorMessage = `Error Code: ${error.status}\nMessage: ${error.message}`;
    }
    console.error(errorMessage);
    return throwError(errorMessage);
  }
}
