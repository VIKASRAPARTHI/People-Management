import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { MatSnackBar } from '@angular/material/snack-bar';
import { PeopleService } from '../../services/people.service';
import { Person } from '../../models/person.model';

@Injectable({
  providedIn: 'root'
})
export class DeletePeopleService {

  constructor(
    private peopleService: PeopleService,
    private snackBar: MatSnackBar
  ) { }

  /**
   * Delete a person with immediate feedback
   * @param person - The person to delete
   * @returns Observable<any> - The delete operation result
   */
  deletePerson(person: Person): Observable<any> {
    console.log('DeletePeopleService: Initiating delete for person:', person);
    const personName = person.name;

    if (!person.id) {
      console.error('DeletePeopleService: Cannot delete person without ID');
      this.showErrorMessage('Cannot delete person: Invalid ID');
      throw new Error('Person ID is required for deletion');
    }

    console.log('DeletePeopleService: Deleting person directly:', personName);

    return new Observable(observer => {
      this.peopleService.deletePerson(person.id!).subscribe({
        next: (result) => {
          console.log('DeletePeopleService: Person deleted successfully');
          this.showSuccessMessage(personName);
          observer.next(result);
          observer.complete();
        },
        error: (error) => {
          console.error('DeletePeopleService: Error deleting person:', error);
          this.showErrorMessage(personName);
          observer.error(error);
        }
      });
    });
  }

  /**
   * Delete multiple people at once
   * @param people - Array of people to delete
   * @returns Observable<any[]> - Array of delete operation results
   */
  deleteMultiplePeople(people: Person[]): Observable<any[]> {
    console.log('DeletePeopleService: Initiating bulk delete for people:', people);

    const deleteOperations = people.map(person => this.deletePerson(person));

    return new Observable(observer => {
      Promise.all(deleteOperations.map(op => op.toPromise()))
        .then(results => {
          console.log('DeletePeopleService: Bulk delete completed successfully');
          this.showBulkSuccessMessage(people.length);
          observer.next(results);
          observer.complete();
        })
        .catch(error => {
          console.error('DeletePeopleService: Error in bulk delete:', error);
          this.showBulkErrorMessage();
          observer.error(error);
        });
    });
  }

  /**
   * Check if a person can be deleted
   * @param person - The person to check
   * @returns boolean - Whether the person can be deleted
   */
  canDeletePerson(person: Person): boolean {
    if (!person) {
      console.warn('DeletePeopleService: Cannot delete null/undefined person');
      return false;
    }

    if (!person.id) {
      console.warn('DeletePeopleService: Cannot delete person without ID:', person);
      return false;
    }

    return true;
  }

  /**
   * Get delete confirmation message for a person
   * @param person - The person to get message for
   * @returns string - The confirmation message
   */
  getDeleteMessage(person: Person): string {
    const personName = person.name;
    return `Are you sure you want to delete ${personName}?`;
  }

  /**
   * Show success message after deletion
   * @param personName - Name of the deleted person
   */
  private showSuccessMessage(personName: string): void {
    this.snackBar.open(
      `${personName} has been deleted successfully`,
      'Close',
      {
        duration: 3000,
        panelClass: ['success-snackbar'],
        horizontalPosition: 'center',
        verticalPosition: 'bottom'
      }
    );
  }

  /**
   * Show error message when deletion fails
   * @param personName - Name of the person that failed to delete
   */
  private showErrorMessage(personName: string): void {
    this.snackBar.open(
      `Failed to delete ${personName}. Please try again.`,
      'Close',
      {
        duration: 5000,
        panelClass: ['error-snackbar'],
        horizontalPosition: 'center',
        verticalPosition: 'bottom'
      }
    );
  }

  /**
   * Show success message for bulk deletion
   * @param count - Number of people deleted
   */
  private showBulkSuccessMessage(count: number): void {
    this.snackBar.open(
      `${count} people have been deleted successfully`,
      'Close',
      {
        duration: 3000,
        panelClass: ['success-snackbar'],
        horizontalPosition: 'center',
        verticalPosition: 'bottom'
      }
    );
  }

  /**
   * Show error message for bulk deletion
   */
  private showBulkErrorMessage(): void {
    this.snackBar.open(
      'Failed to delete some people. Please try again.',
      'Close',
      {
        duration: 5000,
        panelClass: ['error-snackbar'],
        horizontalPosition: 'center',
        verticalPosition: 'bottom'
      }
    );
  }
}
