/*
 * Copyright 2016 Joel Tobey <joeltobey@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * This is the entry point to all JDBC calls.
 */
component
  extends="cfboom.lang.Object"
  displayname="Class QueryService"
  output="false"
{
  property name="interceptorService" inject="coldbox:interceptorService";
  property name="wirebox" inject="wirebox";

  public cfboom.jdbc.models.AbstractServiceSupport function init( required string daoBeanName ) {
    _instance['daoBeanName'] = daoBeanName;
    return this;
  }

  public void function onDIComplete() {
    _instance['dao'] = wirebox.getInstance( _instance.daoBeanName );
  }

  public any function findWhere( required struct criteria, string sortOrder = "", numeric limit = -1 ) {
    return _instance.dao.findWhere( criteria, sortOrder, limit );
  }

  public query function findAll() {
    return findAllWhere( {} );
  }

  public query function findAllWhere( required struct criteria, string sortOrder = "", numeric limit = -1 ) {
    return _instance.dao.findAllWhere( criteria, sortOrder, limit );
  }

  public any function new( required struct criteria ) {
    var newRecordId = javaCast("null", "");
    var generatedKey = _instance.dao.new( criteria );
    if (!isNull(generatedKey))
      newRecordId = generatedKey;

    var idField = _instance.dao.getIdField();
    if (isNull(newRecordId) && !isNull(idField)) {
      for (var key in criteria) {
        if (idField.getName() == key) {
          newRecordId = criteria[key];
          break;
        }
      }
    }

    if (!isNull(newRecordId) && !isNull(idField))
      return _instance.dao.findWhere({"#idField.getName()#":newRecordId});

    if (!isNull(newRecordId))
      return newRecordId;
  }

  public any function update( required any id, required struct criteria ) {
    _instance.dao.update( id, criteria );
    var idField = _instance.dao.getIdField();
    return findWhere({"#idField.getName()#": id});
  }

  public any function executeQuery( required string statement, required struct criteria ) {
    return _instance.dao.executeQuery( statement, criteria );
  }

}
