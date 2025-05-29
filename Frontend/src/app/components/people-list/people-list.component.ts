import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { Person } from '../../models/person.model';
import { PeopleService } from '../../services/people.service';
import { DeletePeopleService } from '../delete-People/delete-people.service';

@Component({
  selector: 'app-people-list',
  templateUrl: './people-list.component.html',
  styleUrls: ['./people-list.component.css']
})
export class PeopleListComponent implements OnInit, OnDestroy {
  people: Person[] = [];
  displayedColumns: string[] = ['avatar', 'name', 'contact', 'actions'];
  loading = true;
  private destroy$ = new Subject<void>();

  constructor(
    private peopleService: PeopleService,
    private router: Router,
    private snackBar: MatSnackBar,
    private deletePeopleService: DeletePeopleService
  ) { }

  ngOnInit() {
    console.log('PeopleListComponent: ngOnInit called');
    this.loadPeople();
  }

  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.complete();
  }

  loadPeople() {
    console.log('PeopleListComponent: loadPeople called');
    this.loading = true;

    // Subscribe to the people observable for real-time updates
    this.peopleService.people$
      .pipe(takeUntil(this.destroy$))
      .subscribe({
        next: (people) => {
          console.log('PeopleListComponent: Received updated people list:', people);
          this.people = people;
          this.loading = false;
        },
        error: (error) => {
          console.error('PeopleListComponent: Error loading people:', error);
          this.snackBar.open('Error loading people', 'Close', { duration: 3000 });
          this.loading = false;
        }
      });
  }

  addPerson() {
    this.router.navigate(['/add']);
  }

  editPerson(person: Person) {
    this.router.navigate(['/edit', person.id]);
  }

  deletePerson(person: Person) {
    console.log('PeopleListComponent: Delete button clicked for person:', person);

    // Use the dedicated delete service
    this.deletePeopleService.deletePerson(person).subscribe({
      next: () => {
        console.log('PeopleListComponent: Person deleted successfully via DeletePeopleService');
        // Success message is handled by the DeletePeopleService
      },
      error: (error) => {
        console.error('PeopleListComponent: Error deleting person via DeletePeopleService:', error);
        // Error message is handled by the DeletePeopleService
      }
    });
  }

  getInitials(fullName: string): string {
    if (!fullName) return '';
    const names = fullName.split(' ');
    const first = names[0] ? names[0].charAt(0).toUpperCase() : '';
    const last = names.length > 1 ? names[names.length - 1].charAt(0).toUpperCase() : '';
    return first + last;
  }
}
