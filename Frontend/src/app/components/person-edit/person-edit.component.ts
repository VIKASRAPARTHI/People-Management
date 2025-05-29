import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { PersonCreateRequest, PersonUpdateRequest } from '../../models/person.model';
import { PeopleService } from '../../services/people.service';

@Component({
  selector: 'app-person-edit',
  templateUrl: './person-edit.component.html',
  styleUrls: ['./person-edit.component.css']
})
export class PersonEditComponent implements OnInit {
  personForm: FormGroup;
  isEditMode = false;
  personId: number | null = null;
  loading = false;
  submitting = false;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private peopleService: PeopleService,
    private snackBar: MatSnackBar
  ) {
    this.personForm = this.createForm();
  }

  ngOnInit() {
    this.route.params.subscribe(params => {
      if (params['id']) {
        this.isEditMode = true;
        this.personId = +params['id'];
        this.loadPerson();
      }
    });
  }

  createForm(): FormGroup {
    return this.fb.group({
      name: ['', [Validators.required, Validators.minLength(2)]],
      age: ['', [Validators.required, Validators.min(0), Validators.max(150)]],
      gender: ['', [Validators.required]],
      mobileNumber: ['', [Validators.required, Validators.pattern(/^[\+]?[1-9][\d]{9,14}$/)]]
    });
  }

  loadPerson() {
    if (!this.personId) return;

    this.loading = true;
    this.peopleService.getPerson(this.personId).subscribe({
      next: (person) => {
        this.personForm.patchValue({
          name: person.name,
          age: person.age,
          gender: person.gender,
          mobileNumber: person.mobileNumber
        });
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading person:', error);
        this.snackBar.open('Error loading person data', 'Close', { duration: 3000 });
        this.loading = false;
        this.router.navigate(['/']);
      }
    });
  }

  onSubmit() {
    if (this.personForm.invalid) {
      this.markFormGroupTouched();
      return;
    }

    this.submitting = true;
    const formValue = this.personForm.value;

    if (this.isEditMode && this.personId) {
      // Update existing person
      const updateRequest: PersonUpdateRequest = {
        name: formValue.name,
        age: parseInt(formValue.age),
        gender: formValue.gender,
        mobileNumber: formValue.mobileNumber
      };

      this.peopleService.updatePerson(this.personId, updateRequest).subscribe({
        next: () => {
          this.snackBar.open('Person updated successfully', 'Close', { duration: 3000 });
          this.router.navigate(['/']);
        },
        error: (error) => {
          console.error('Error updating person:', error);
          this.snackBar.open('Error updating person', 'Close', { duration: 3000 });
          this.submitting = false;
        }
      });
    } else {
      // Create new person
      const createRequest: PersonCreateRequest = {
        name: formValue.name,
        age: parseInt(formValue.age),
        gender: formValue.gender,
        mobileNumber: formValue.mobileNumber
      };

      this.peopleService.createPerson(createRequest).subscribe({
        next: () => {
          this.snackBar.open('Person created successfully', 'Close', { duration: 3000 });
          this.router.navigate(['/']);
        },
        error: (error) => {
          console.error('Error creating person:', error);
          this.snackBar.open('Error creating person', 'Close', { duration: 3000 });
          this.submitting = false;
        }
      });
    }
  }

  onCancel() {
    this.router.navigate(['/']);
  }

  private markFormGroupTouched() {
    Object.keys(this.personForm.controls).forEach(key => {
      const control = this.personForm.get(key);
      if (control) {
        control.markAsTouched();
      }
    });
  }

  getErrorMessage(fieldName: string): string {
    const control = this.personForm.get(fieldName);
    if (control && control.hasError('required')) {
      return `${fieldName} is required`;
    }
    if (control && control.hasError('minlength')) {
      return `${fieldName} must be at least ${control.errors['minlength'].requiredLength} characters`;
    }
    if (control && control.hasError('min')) {
      return `${fieldName} must be at least ${control.errors['min'].min}`;
    }
    if (control && control.hasError('max')) {
      return `${fieldName} must be at most ${control.errors['max'].max}`;
    }
    if (control && control.hasError('pattern')) {
      return 'Please enter a valid mobile number (e.g., +1234567890)';
    }
    return '';
  }
}
