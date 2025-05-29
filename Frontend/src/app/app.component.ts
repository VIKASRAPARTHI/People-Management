import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'people-manager';

  ngOnInit() {
    console.log('AppComponent: ngOnInit called - Application is starting');
  }
}
